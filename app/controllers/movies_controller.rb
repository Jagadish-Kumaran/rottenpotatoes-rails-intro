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
    @movies = Movie.all
    #@movies = Movie.order(params[:sort_header])
    
    #redirect flag is used to suggest if a url must be redirected based on session parameters
    redirect_flag=0
    
    if params[:sort_header]
     #@sort_order = params[:order]
      @movies = Movie.order(params[:sort_header])
      session[:sort_header]=params[:sort_header]
    elsif session[:sort_header]
      #@sort_order = session[:order]
      @movies = Movie.order(session[:sort_header])
      redirect_flag = 1
      
    end
    
    @all_ratings = Movie.all_ratings
    
    if params[:ratings]
      @ratings=params[:ratings]
      session[:ratings] = @ratings
      @movies=@movies.where(rating: @ratings.keys)
    elsif session[:ratings]
      @ratings=session[:ratings]
      @movies=@movies.where(rating: @ratings.keys)
      redirect_flag = 1
    #else  
      #@movies=@movies
    end 
    
    if redirect_flag==1
      flash.keep
      redirect_to movies_path(sort_header: session[:sort_header],ratings: session[:ratings])
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
