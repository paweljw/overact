module Web
  module Controllers
    module Compare
      class Show
        include Web::Action

        expose :movie1, :movie2, :overlap

        def call(params)
          movie_repo = MovieRepository.new

          @movie1 = movie_repo.find_by_tt(tt_id: params[:movie1])
          unless @movie1
            movie_object = Movie.new(tt_id: params[:movie1], name: 'Pending')
            @movie1 = movie_repo.create(movie_object)
            MovieSyncWorker.perform_async(params[:movie1])
          end

          @movie2 = movie_repo.find_by_tt(tt_id: params[:movie2])
          unless @movie2
            movie_object = Movie.new(tt_id: params[:movie2], name: 'Pending')
            @movie2 = movie_repo.create(movie_object)
            MovieSyncWorker.perform_async(params[:movie2])
          end

          if @movie1.checked? && @movie2.checked?
            role_repo = RoleRepository.new
            actor_repo = ActorRepository.new
            overlapping_actors = role_repo.find_by_movie_overlap(movie1_id: @movie1.id, movie2_id: @movie2.id)

            @overlap = overlapping_actors.map do |role|
              actor_id = role[:actor_id]
              [
                actor_repo.find(actor_id),
                role_repo.find_by_movie_and_actor(movie_id: @movie1.id, actor_id: actor_id),
                role_repo.find_by_movie_and_actor(movie_id: @movie2.id, actor_id: actor_id)
              ]
            end
          end
        end
      end
    end
  end
end
