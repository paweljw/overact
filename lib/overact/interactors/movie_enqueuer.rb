# frozen_string_literal: true

class MovieEnqueuer
  include Hanami::Interactor

  expose :movie

  def initialize(repo: MovieRepository.new, worker: MovieSyncWorker)
    @repo = repo
    @worker = worker
  end

  def call(tt_id:)
    @movie = @repo.find_by_tt(tt_id: tt_id)

    unless @movie
      @movie = @repo.create({ tt_id: tt_id, name: 'Pending' })
      @worker.perform_async(tt_id)
    end

    @movie
  end
end
