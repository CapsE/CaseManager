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

get "/" do
  @groups = Group.order("created_at DESC")
  @caseses = Case.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

get "/result" do
	erb :result
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
	get "/caseses/create" do
		@title = "Create Case"
		@case = Case.new
		erb :"caseses/create"
	end
	
	# In die Datenbank ablegen
	post "/caseses" do
		@case = Case.new(params[:post])
		if @case.save
			redirect "/"
		else
			redirect "caseses/create", :error => 'Something went wrong. Try again.'
		end
	end
	
	# Interface Groups
	get "/groups/create" do
		@groups = Group.order("created_at DESC")
		@caseses = Case.order("created_at DESC")
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
	get "/caseses/edit/:id" do
		@title = "Edit Case"
		@case = Case.find(params[:id])
		erb:"caseses/edit"
	end
	
	# In die Datenbak eintragen
	post "/caseses/edit" do
		@case = Case.update(params[:post][:id], params[:post])
		 if @case.save
			redirect "/"
		  else
			redirect "/caseses/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
		  end
	end
	
	# Interface Group editieren
	get "/groups/edit/:id" do
		@title = "Edit Groups"
		@groups = Group.order("created_at DESC")
		@caseses = Case.order("created_at DESC")
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
	get "/caseses/delete/:id" do
		Case.delete(params[:id])
		redirect "/"
	end
	
	# Delete Group
	get "/groups/delete/:id" do
		Group.delete(params[:id])
		redirect "/"
	end

end



