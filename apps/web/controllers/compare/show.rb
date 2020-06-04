module Web
  module Controllers
    module Compare
      class Show
        include Web::Action

        expose :movie1, :movie2, :overlapping_roles

        params do
          required(:movie1).filled(:str?, format?: /\Att\d{1,}/)
          required(:movie2).filled(:str?, format?: /\Att\d{1,}/)
        end

        def initialize(movie_enqueuer: MovieEnqueuer.new, overlap_finder: OverlapFinder.new)
          @movie_enqueuer = movie_enqueuer
          @overlap_finder = overlap_finder
        end

        def call(params)
          if params.valid?
            @movie1 = @movie_enqueuer.call(tt_id: params[:movie1]).movie
            @movie2 = @movie_enqueuer.call(tt_id: params[:movie2]).movie

            if @movie1.checked? && @movie2.checked?
              @overlapping_roles = @overlap_finder.call(movie1_id: @movie1.id, movie2_id: @movie2.id).overlap
            end
          end
        end
      end
    end
  end
end
