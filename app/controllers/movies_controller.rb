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
		@all_ratings = Movie.unique_ratings
		if (params[:clicked] == 'title')
			@movies = Movie.order(:title)
			@hl_title = 'hilite'
		elsif (params[:clicked] == 'release')
			@movies = Movie.order(:release_date)
			@hl_release = 'hilite'
		else
			@movies = Movie.all
		end
		# puts 'checked is', @checked
		# puts 'all_ratings is', @all_ratings
		# puts 'params ratings is"', params[:ratings]
		# @checked = ((defined? params[:ratings]) != nil) ? params[:ratings] : @all_ratings
		if params[:ratings]
			@checked = params[:ratings]
			@movies = @movies.select { |movie| @checked.include? movie.rating }
		elsif session[:ratings]
			@checked = session[:ratings]
			@movies = @movies.select { |movie| @checked.include? movie.rating }
		else
			# Check all boxes by default
			@checked = Hash[@all_ratings.zip([1,1,1,1])]
		end
		session[:ratings] = @checked
		puts 'Selected ratings were: ', session[:ratings]
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
