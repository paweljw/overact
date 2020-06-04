require 'spec_helper'

RSpec.describe PromoteActorPhoto do
  let(:repo) { instance_double('ActorRepository') }
  let(:attacher) { instance_double('PhotoUploader::Attacher') }

  before { allow(repo).to receive(:find).and_return(actor) }

  context 'with no image_url' do
    let(:actor) { Actor.new(name: 'whatever', image_url: nil) }

    it 'returns early' do
      expect(attacher).to_not receive(:assign_remote_url)

      PromoteActorPhoto.new(repo: repo, attacher: attacher).call(actor_id: 1)
    end
  end

  context 'with photo_data present' do
    let(:actor) { Actor.new(photo_data: { present: 'yes' }) }

    it 'returns early' do
      expect(attacher).to_not receive(:assign_remote_url)

      PromoteActorPhoto.new(repo: repo, attacher: attacher).call(actor_id: 1)
    end
  end

  context 'with processable actor' do
    let(:actor) { Actor.new(image_url: 'an_url') }

    it 'calls attacher and saves' do
      expect(attacher).to receive(:assign_remote_url).with('an_url')
      expect(attacher).to receive(:promote)
      expect(attacher).to receive(:data).and_return('data double')
      expect(repo).to receive(:update).with(1, photo_data: 'data double')

      PromoteActorPhoto.new(repo: repo, attacher: attacher).call(actor_id: 1)
    end
  end
end
