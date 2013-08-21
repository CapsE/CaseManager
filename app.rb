begin # Library imports

	require 'sinatra'
	require 'sinatra/activerecord'
	require './environments'
	require 'sinatra/flash'
	require 'sinatra/redirect_with_flash'
	require './runner'
	require './basic'

	enable :sessions
end

begin # Klassen definitionen der Datenbank elemente
	class Group < ActiveRecord::Base
		validates :elements, presence: true, length: { minimum: 2 }
	end

	class Case < ActiveRecord::Base
		validates :code, presence: true
	end
end

#Funktion zum erstellen der Baumstrucktur
def ParseElements group, elements
	@tree += "<div class='tree_group' data-active='false' data-addid='G#{group.id}' id='#{group.tags}'><img class='identifier' data-id=\"item_#{@id}\" src='/Icons/hide.png' onclick='Toggle(event, \"item_#{@id}\")'>"
	@tree += "  #{group.tags}"
	elements.each do |el|
		el = el.tr("$","#")
		puts "--------------------------------------------------"
		puts eval('"' + el + '"')
		puts "--------------------------------------------------"
		@tree += eval('"' + el + '"')
	end
	@tree += "<ul id='item_#{@id}'>"
	@id +=1
	group.elements.split(",").each do |el|
		if el[0] == "C"
			c = Case.find(el[1..-1])
			@tree += "<li class='tree_case' data-active='false'>#{c.tags}</li>"
		else
			g = Group.find(el[1..-1])
			ParseElements(g, elements)
		end
	end
	@tree += "</ul></div>"
end

get "/" do
	@groups = Group.order("created_at DESC")
	@tree = ""
	@id = 0
	elements = ["<a href='/run/${group.id}'><img class='control' src='/Icons/play.png'></a>","<a href='/groups/edit/\${group.id}'><img class='control' src='/Icons/edit.png'></a>"]
	@groups.each do |group|
		ParseElements(group, elements) 
	end
	@cases = Case.order("created_at DESC")
	@cases = @cases.sort_by &:tags
	@title = "Welcome."
	erb :"posts/index"
end

get "/result" do
	erb :result
end

#Downloads aus dem Ordner files ermöglichen
get '/download/:filename' do |filename|
  send_file "./files/#{filename}", :filename => filename, :type => 'Application/octet-stream'
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

begin # Erstellen von Caseses und Groups
	# Interface Caseses
	get "/cases/create" do
		@title = "Create Case"
		@case = Case.new
		erb :"cases/create"
	end
	
	# In die Datenbank ablegen
	post "/cases" do
		@case = Case.new(params[:post])
		if @case.save
			redirect "/"
		else
			redirect "cases/create", :error => 'Something went wrong. Try again.'
		end
	end
	
	# Interface Groups
	get "/groups/create" do
		@groups = Group.order("created_at DESC")
		@tree = ""
		@id = 0
		elements = ["<img class='control' src='/Icons/add.png' style='margin-left:5px;' onclick='AddMe(\\\"${group.tags}\\\", true)'></img>"]
		@groups.each do |group|
			ParseElements(group, elements) 
		end
		@cases = Case.order("created_at DESC")
		@title = "Create Group"
		@group = Group.new
		erb :"groups/create"
	end
	
	# In die Datenbank ablegen
	post "/groups" do
		@group = Group.new(params[:post])
		
		if @group.save
			redirect "/"
		else
			redirect "groups/create", :error => 'Something went wrong. Try again.'
		end
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
		@cases = Case.order("created_at DESC")
		@group = Group.find(params[:id])
		erb:"groups/edit"
	end
	
	# In die Datenbak eintragen
	post "/groups/edit" do
		@group = Group.update(params[:post][:id], params[:post])
		 if @group.save
			redirect "/"
		  else
			redirect "/groups/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
		  end
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



