# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions


class Post < ActiveRecord::Base
end

class Thing < ActiveRecord::Base
end

get "/" do
  @posts = Post.order("created_at DESC")
  @things = Thing.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

get "/posts/create" do
  @title = "Create post"
  @post = Thing.new
  erb :"posts/create"
end

post "/posts" do
  @post = Thing.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}"
  else
    redirect "posts/create", :error => 'Something went wrong. Try again.'
  end
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