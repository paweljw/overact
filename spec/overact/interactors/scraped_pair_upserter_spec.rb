require 'spec_helper'

RSpec.describe ScrapedPairUpserter do
  let(:actor_upserter) { instance_double('ActorUpserter') }
  let(:role_upserter) { instance_double('RoleUpserter') }
  let(:interactor) { ScrapedPairUpserter.new(actor_upserter: actor_upserter, role_upserter: role_upserter) }
  let(:args) { OpenStruct.new(name: 'name', 'tt_id': 'tt123', image_url: 'abc', character_name: 'chara') }
  let(:actor) { double(actor: double(id: 3)) }

  it 'upserts scraped pair' do
    expect(actor_upserter).to receive(:call).with(name: 'name', tt_id: 'tt123', image_url: 'abc').and_return(actor)
    expect(role_upserter).to receive(:call).with(movie_id: 1, actor_id: 3, character_name: 'chara')

    interactor.call(movie_id: 1, scraped_pair: args)
  end
end
