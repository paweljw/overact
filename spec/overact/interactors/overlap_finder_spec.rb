require 'spec_helper'

RSpec.describe OverlapFinder do
  let(:role_repo) { instance_double('RoleRepository') }
  let(:actor_repo) { instance_double('ActorRepo') }

  let(:role1) { { actor_id: 3 } }
  let(:role2) { double }
  let(:actor) { Actor.new }
  let(:overlapping_actors) { [role1] }

  let(:interactor) { OverlapFinder.new(role_repo: role_repo, actor_repo: actor_repo) }

  describe '#call' do
    it 'processes and exposes array of arrays' do
      expect(role_repo).to receive(:find_by_movie_overlap).with(movie1_id: 1, movie2_id: 2).and_return(overlapping_actors)
      expect(role_repo).to receive(:find_by_movie_and_actor).with(movie_id: 1, actor_id: 3).and_return(role2)
      expect(actor_repo).to receive(:find).with(3).and_return(actor)

      overlap = interactor.call(movie1_id: 1, movie2_id: 2).overlap.first

      expect(overlap[0]).to eq actor
      expect(overlap[1]).to eq role2
      expect(overlap[2].actor_id).to eq 3
    end
  end
end
