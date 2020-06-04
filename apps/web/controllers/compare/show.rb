module Web
  module Controllers
    module Compare
      # TODO: validate parameters
      # TODO: introduce presenters for overlaps
      class Show
        include Web::Action

        expose :movie1, :movie2, :overlap

        def call(params)
          @movie1 = MovieEnqueuer.new.call(tt_id: params[:movie1]).movie
          @movie2 = MovieEnqueuer.new.call(tt_id: params[:movie2]).movie

          if @movie1.checked? && @movie2.checked?
            @overlap = OverlapFinder.new
              .call(movie1_id: @movie1.id, movie2_id: @movie2.id).overlap
              .map { |o| OverlapPresenter.new(o) }
          end
        end
      end
    end
  end
end
