# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require './runner'
require './basic'

enable :sessions


class Group < ActiveRecord::Base
end

class Case < ActiveRecord::Base
end

class Gc_relation < ActiveRecord::Base
end

class Gg_relation < ActiveRecord::Base
end

get "/" do
  @groups = Group.order("created_at DESC")
  @caseses = Case.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

get "/caseses/create" do
  @title = "Create Case"
  @case = Case.new
  erb :"caseses/create"
end

get "/caseses/edit/:id" do
	@title = "Edit Case"
	@case = Case.find(params[:id])
	erb:"caseses/edit"
end

get "/groups/create" do
  @groups = Group.order("created_at DESC")
  @caseses = Case.order("created_at DESC")
  @title = "Create Group"
  @group = Group.new
  erb :"groups/create"
end

get "/groups/edit/:id" do
	@title = "Edit Groups"
	@groups = Group.order("created_at DESC")
	@caseses = Case.order("created_at DESC")
	@group = Group.find(params[:id])
	erb:"groups/edit"
end

post "/groups/edit" do
	@group = Group.update(params[:post][:id], params[:post])
	 if @group.save
		redirect "/"
	  else
		redirect "/groups/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
	  end
end

get "/groups/delete/:id" do
	Group.delete(params[:id])
	redirect "/"
end

get "/caseses/delete/:id" do
	Case.delete(params[:id])
	redirect "/"
end

post "/caseses" do
  @case = Case.new(params[:post])
  if @case.save
    redirect "/"
  else
    redirect "caseses/create", :error => 'Something went wrong. Try again.'
  end
end

post "/caseses/edit" do
	@case = Case.update(params[:post][:id], params[:post])
	 if @case.save
		redirect "/"
	  else
		redirect "/caseses/edit/#{params[:id]}", :error => 'Something went wrong. Try again.'
	  end
end

post "/groups" do
	@group = Group.new(params[:post])
	
	if @group.save
		redirect "/"
	else
		redirect "groups/create", :error => 'Something went wrong. Try again.'
	end
end

get "/result" do
	erb :result
end

get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"posts/view"
end

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
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