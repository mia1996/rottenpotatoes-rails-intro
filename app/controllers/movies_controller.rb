class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.get_all_ratings
    
    if params[:ratings].nil? and params[:sort_by].nil?
      flash.keep
      redirect_to movies_path({sort_by: session["sort_by"], ratings: session["all_ratings_selected"]})
      
    if not params[:ratings].nil?
      session["selected_ratings"] = params[:ratings].keys
      session["all_ratings_selected"] = params[:ratings]
    end

    if not params[:sort_by].nil?
      session["sort_by"] = params[:sort_by]
    end

    if session["selected_ratings"].nil?
      session["selected_ratings"] = @all_ratings
      tmp_arr = Array.new(@all_ratings.size, 1)
      session["all_ratings_selected"] = Hash[@all_ratings.zip(tmp_arr)]
    end

    if params[:ratings].nil? and params[:sort_by].nil?
      flash.keep
      redirect_to movies_path({sort_by: session["sort_by"], ratings: session["all_ratings_selected"]})
    end

    if session["sort_by"] == "title"
      @movies = Movie.with_ratings_sort(session["selected_ratings"], :title)
      @title_hilite = "hilite"
      @release_date_hilite = nil
    elsif session["sort_by"] == "release_date"
      @movies = Movie.with_ratings_sort(session["selected_ratings"], :release_date)
      @release_date_hilite = "hilite"
      @title_hilite = nil
    else
      @movies = Movie.with_ratings(session["selected_ratings"])
      @title_hilite = nil
      @release_date_hilite = nil
    end

    
    @all_ratings_selected = session["all_ratings_selected"]
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

end

