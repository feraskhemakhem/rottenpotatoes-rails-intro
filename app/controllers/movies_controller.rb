class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # for part 2
    # @checked_ratings = @all_ratings
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings # retrieves all movie ratings for part 2
    # "Therefore, if you find that the incoming URI is lacking the right params[] and you're forced to fill them in from the session[]"
    @sort = params[:sort] || session[:sort]
    # for part 3
    # save the last session in session hash (or all ratings as a default)
    # Hash[@all_ratings.map {|k| [k, []]}]
    session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
    
    # part 2/3: if unchecked, use session[] hash (part 3)
    @checked_ratings = params[:ratings] || session[:ratings]
    
    # part 3: "save" this session
    session[:sort] = @sort
    session[:ratings] = @checked_ratings

    # part 2: only get movies in the checked ratings
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    
    # part 3: edge case: if params and session mismatch because 
    if (params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end
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
