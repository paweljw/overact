require 'spec_helper'

RSpec.describe MovieEnqueuer do
  let(:repo) { instance_double('MovieRepository') }
  let(:worker) { double('MovieSyncWorker') }
  let(:created_movie) { double }

  let(:interactor) { MovieEnqueuer.new(repo: repo, worker: worker) }

  before { allow(repo).to receive(:find_by_tt).and_return(movie) }

  context 'when movie not found' do
    let(:movie) { nil }

    it 'creates a movie and enqueues a check, exposing movie' do
      expect(repo).to receive(:create).with({ tt_id: 'tt123', name: 'Pending' }).and_return(created_movie)
      expect(worker).to receive(:perform_async).with('tt123')

      expect(interactor.call(tt_id: 'tt123').movie).to eq created_movie
    end
  end

  context 'when movie found' do
    let(:movie) { double('Movie') }

    it 'creates a movie and enqueues a check, exposing movie' do
      expect(repo).to_not receive(:create)
      expect(worker).to_not receive(:perform_async)

      expect(interactor.call(tt_id: 'tt123').movie).to eq movie
    end
  end
end
