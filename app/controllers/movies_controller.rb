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
		# session.clear
		@all_ratings = Movie.unique_ratings

		if params[:ratings]
			@checked = params[:ratings]
		elsif session[:ratings]
			@checked = session[:ratings]
		else
			# Check all boxes by default
			@checked = Hash[@all_ratings.zip([1,1,1,1])]
		end
		session[:ratings] = @checked

		# Check URI for sorting params. If not available, take from session
		if (params[:clicked] == 'title')
			@movies = Movie.order(:title).where(rating: @checked.keys)
			@hl_title = 'hilite'
			session[:clicked] = 'title'
		elsif (params[:clicked] == 'release')
			@movies = Movie.order(:release_date).where(rating: @checked.keys)
			@hl_release = 'hilite'
			session[:clicked] = 'release'
		elsif (session[:clicked] == 'title') or (session[:clicked] == 'release')
			@movies = Movie.order(:title)
			@hl_title = 'hilite'
			redirect_to movies_path(clicked: session[:clicked], ratings: @checked)
		else
			@movies = Movie.all
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
