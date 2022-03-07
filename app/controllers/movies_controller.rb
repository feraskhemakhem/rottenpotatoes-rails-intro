class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # for part 2
    @checked_Ratings = @all_ratings
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings # retrieves all movie ratings for part 2
    @sort = params[:sort]
    # if there are no selected ratings then choose all by default (otherwise get the keys of the current ratings hash)
    # also make a variable so that the checklist can check
    @checked_ratings = params[:ratings].nil? ? @all_ratings : params[:ratings].keys
    @movies = Movie.where(rating: @checked_ratings).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end
  
  # part 2: returns the rating of a movie
  def rat
    @movie.rating
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
