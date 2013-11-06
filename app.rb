begin # Library imports

	require 'sinatra'
	require 'sinatra/activerecord'
	require 'sinatra/cookies'
	require 'sinatra/streaming'
	require './environments'
	require 'sinatra/flash'
	require 'sinatra/redirect_with_flash'
	require 'json'
	require './runner'
	require './basic'

	enable :sessions
	set :bind, '0.0.0.0'
end

$tree_group = 0
$id_control = 0

begin # Klassen definitionen der Datenbank elemente
	class Group < ActiveRecord::Base
		validates :elements, presence: true, length: { minimum: 2 }
		validates :tags, presence: true, length: { minimum: 2 }
		
		#########################################################################################################
		#	Erzeugt den HTML-code um die Gruppe anzuzeigen.
		#--------------------------------------------------------------------------------------------------------
		#	<= controls	//Ein Array mit HTML-Elmenten im String format. Das #{} muss durch ${} ersetzt werden
		#--------------------------------------------------------------------------------------------------------
		#	=> @html	//Ein String der das Fertige HTML-Element enthält
		#########################################################################################################
		def to_tree controls = nil
			#Haupt-Container und Toggle Button
			@html = "<li id='#{$id_control}' class='tree_group' data-id='G#{self.id}' data-searchid='#{self.name}' draggable='true' OnMouseDown='StartMove(event)' ondragstart='drag(event)'><img class='identifier' data-id=\"T#{$tree_group}\" src='/Icons/hide.png' onclick='Toggle(event, \"T#{$tree_group}\")'>"
			$id_control += 1
			#Beschriftung
			@html += "<div class='tree_group' data-active='false'>#{self.name}"
			#Zusätzliche Controls falls vorhanden
			if controls
				controls.each do |el|
					el = el.tr("$","#")
					@html += eval('"' + el + '"')
				end
			end
			@html += "</div>"
			#Container für Unterelemente
			@html += "<ul id='T#{$tree_group}'>"
			$tree_group += 1
			#Alle Unterelemente (Rekursiv)
			self.elements.split(",").each do |el|
				if el[0] == "C"
					c = Case.find(el[1..-1])
					@html += c.to_tree
				else
					g = Group.find(el[1..-1])
					@html += g.to_tree
				end
			end	
			#Alle Container schließen
			@html += "</ul></li>"
			return @html
		end
		
		def to_html controls = nil
			@html = "<div id='#{self.tags}' class='tree_group' data-search='true'>#{self.tags}"
			if controls
				controls.each do |el|
					el = el.tr("$","#")
					@html += eval('"' + el + '"')
				end
			end
			@html += "</div>"
			return @html
		end
	end

	class Case < ActiveRecord::Base
		validates :code, presence: true
		
		def to_tree
			@html = "<li id='#{self.name}' data-search='true'>#{self.name}</li>"
			return @html
		end
	end
	
	class Tag < ActiveRecord::Base
	  validates :name, presence: true
	  validates :object, presence: true
	  #validates_uniqueness_of :name, scope: :object
	end
end

begin # Used Variables
	@groups = []
	@cases = []
	@tags = ""
end

begin # Helper
	def cookieSelect
		@rel = []
		if @tags != "" && @tags != nil
			arr = @tags.split(",")
			if arr == []
				arr = [@tags]
			end
			arr.each do |t|
				if t != ""
					search = Tag.where("name LIKE '#{t}'")
					if search
						search.each do |s|
							@rel << s.object
						end
					end
				end
			end
		@rel.each do |r|
		   if r[0] == "G"
			   @groups << Group.find(r[1..-1])
		   elsif r[0] == "C"
			   @cases << Case.find(r[1..-1])
		   end
		end
	  else
		 @groups = Group.order("name DESC")
		 @cases = Case.order("name DESC")
	  end
	end

	before do
		@cookies = request.cookies
  	if @cookies["tags"]
  		@tags = @cookies["tags"]
  		if @tags[0] == ","
  			@tags = @tags[1..-1]
  		end
  		if @tags[-1] == ","
  			@tags = @tags[0..-2]
  		end
  	end
	end
	
	helpers do
		def title
			if @title
				"#{@title}"
			else
				"Welcome."
			end
		end
	end
end

get "/" do
	@groups = []
	@cases = []

  cookieSelect()
	@tree = ""
	@id = 0
	@elements = ["<a href='/run/${self.id}'><img class='control' src='/Icons/play.png'></a>","<a href='/groups/edit/\${self.id}'><img class='control' src='/Icons/edit.png'></a>"]
	#@cases = Case.where("tags IS NOT ''")
	#@cases = @cases.sort_by &:tags
	@title = "Runic"
	erb :"index"
end

get "/result/:id" do
	f = File.open("files/results/#{params[:id]}")
	@tree = f.read
	erb :result
end

#Downloads aus dem Ordner files ermöglichen
get '/download/:filename' do |filename|
  send_file "./files/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

begin # Erstellen von Caseses und Groups
	def createTags tags, preChar
    tags.split(",").each do |t|
      #puts "New Relation: " + {"name" => t, "object" => preChar + @case.id.to_s}.to_s
      if preChar == "C"
        newTag = Tag.new({"name" => t, "object" => preChar + @case.id.to_s})
      else
        newTag = Tag.new({"name" => t, "object" => preChar + @group.id.to_s})
      end
      if newTag.save
        puts "Tag safed"
      else
        redirect "cases/create", :error => 'Something went wrong with the Tags. Try again.'
      end
    end
	end
	
	# Interface Caseses
	get "/cases/create" do
		@title = "Create Case"
		erb :"cases/create"
	end
	
	# In die Datenbank ablegen
	post "/cases" do
		puts "----------------------------------------------"
		puts params[:post]
		puts "----------------------------------------------"
		@case = Case.new(params[:post])
		if @case.save
      createTags(params[:post]["tags"], "C")
		else
			redirect "cases/create", :error => 'Something went wrong. Try again.'
		end
		redirect "/"
	end
	
	# Interface Caseses für Popup
	get "/cases/create/direct" do
		@title = "Create Case"
		erb :"cases/createPopup", :layout => false
	end
	
	# In die Datenbank ablegen aus einem Popup Fenster
	post "/cases/direct" do
		puts "----------------------------------------------"
    puts params[:post]
    puts "----------------------------------------------"
    @case = Case.new(params[:post])
    if @case.save
      createTags(params[:post]["tags"], "C")
    else
      redirect "cases/create", :error => 'Something went wrong. Try again.'
    end
	   redirect "popup/close/#{@case.id}"
	end
	
	get "/popup/close/:id" do
		@case = Case.find(params[:id])
		erb :"cases/closePopup", :layout => false
	end
	
	# Interface Groups
	get "/groups/create" do
	  @groups = []
    @cases = []
	  
	  cookieSelect()
		#@groups = Group.order("created_at DESC")
		@tree = ""
		@id = 0
		@elements = []

		#@cases = Case.where("tags IS NOT ''")
		@title = "Create Group"
		@group = Group.new
		erb :"groups/create"
	end
	
	# In die Datenbank ablegen
	post "/groups" do
		@group = Group.new(params[:post])
		if @group.save
		  createTags(params[:post]["tags"], "G")
		else
			redirect "groups/create", :error => 'Something went wrong. Try again.'
		end
		redirect "/"
	end 
end

begin # Editieren von Caseses und Groups
	
	# Interface Case editieren
	get "/cases/edit/:id" do
		@title = "Edit Case"
		@case = Case.find(params[:id])
		erb:"cases/edit"
	end
	
	# In die Datenbak eintragen
	post "/cases/edit" do
		@case = Case.update(params[:post][:id], params[:post])
		params[:post]["tags"].split(",").each do |t|
      t.gsub!(" ", "")
      Tag.new({"name" => t, "object" => "C" + @case.id.to_s})
    end
		 if @case.save
			redirect "/"
		  else
			redirect "/cases/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
		  end
	end
	
	# Interface Group editieren
	get "/groups/edit/:id" do
		@title = "Edit Groups"
		@groups = Group.order("created_at DESC")
		@cases = Case.where("tags IS NOT ''")
		@group = Group.find(params[:id])
		erb:"groups/edit"
	end
	
	# In die Datenbak eintragen
	post "/groups/edit" do
		@group = Group.update(params[:post][:id], params[:post])
		params[:post]["tags"].split(",").each do |t|
      t.gsub!(" ", "")
      Tag.new({"name" => t, "object" => "G" + @group.id.to_s})
    end
		 if @group.save
			redirect "/"
		  else
			redirect "/groups/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
		  end
	end
end

begin # JSON Daten anfordern
	# GET Group als JSON
	get "/json/group/:id" do
		content_type :json
		@group = Group.find(params[:id])
		return @group.to_json
	end
	
	#Get Case als JSON
	get "/json/case/:id" do
		content_type :json
		@case = Case.find(params[:id])
		return @case.to_json
	end
	
	get "/test" do
	   response.set_cookie("tags", "")
	end
end

begin # Löschen von Cases und Groups

	# Delete Case
	get "/cases/delete/:id" do
		Case.delete(params[:id])
		redirect "/"
	end
	
	# Delete Group
	get "/groups/delete/:id" do
		Group.delete(params[:id])
		redirect "/"
	end

end

begin # Library Features
  get "/library" do
    if $gems == nil
      $gems = %x[gem list -d --no-details].split(/\n/)
    end
    erb :library
  end
  
  post "/gem" do
    puts "installing #{params[:gem]}"
    $gems = nil
    gem install params[:gem]
    redirect "/library"
  end
end



