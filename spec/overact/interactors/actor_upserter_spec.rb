require 'spec_helper'

RSpec.describe ActorUpserter do
  let(:actor_repo) { instance_double('ActorRepository') }
  let(:worker) { double('PhotoDownloadWorker') }
  let(:interactor) { described_class.new(actor_repo: actor_repo, worker: worker) }
  let(:actor) { double(id: 123) }

  context 'when actor already existed' do

    it 'returns the actor' do
      expect(actor_repo).to receive(:find_by_tt).and_return(actor)
      expect(actor_repo).to_not receive(:create)
      expect(worker).to_not receive(:perform_async)

      expect(interactor.call({}).actor).to eq actor
    end
  end

  context 'when actor did not previously exist' do
    it 'creates and returns the actor' do
      expect(actor_repo).to receive(:find_by_tt).and_return(nil)
      expect(actor_repo).to receive(:create).with({}).and_return(actor)
      expect(worker).to receive(:perform_async).with(123)

      expect(interactor.call({}).actor).to eq actor
    end
  end
end
