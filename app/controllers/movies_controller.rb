class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if !params[:orderby].nil?
      session[:orderby] = params[:orderby]
      if params[:orderby] == "title"
        @movies = Movie.order("title") 
      elsif params[:orderby] == "release_date"
        @movies = Movie.order("release_date")
      end
    elsif !session[:orderby].nil?
      @movies = Movie.order(session[:orderby])
    else
      @movies = Movie.all    
    end
    
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      @movies = Movie.find(:all, :conditions => {:rating => session[:ratings].keys})
    elsif !session[:ratings].nil?
      @movies = Movie.find(:all, :conditions => {:rating => session[:ratings].keys})
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
