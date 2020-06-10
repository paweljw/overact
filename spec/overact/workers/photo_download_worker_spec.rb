# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhotoDownloadWorker do
  let(:interactor) { instance_double('PromoteActorPhoto') }

  it 'calls interactor' do
    expect(interactor).to receive(:call).with(actor_id: 1)

    PhotoDownloadWorker.new.perform(1, interactor: interactor)
  end
end
