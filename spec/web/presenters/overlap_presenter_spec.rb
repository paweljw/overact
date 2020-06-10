# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Web::OverlapPresenter do
  let(:overlap) { [actor, role1, role2] }

  let(:actor) { Actor.new }
  let(:role1) { Role.new }
  let(:role2) { Role.new }

  let(:presenter) { described_class.new(overlap) }

  describe '#actor' do
    it 'exposes a presenter' do
      expect(presenter.actor).to be_a(Web::ActorPresenter)
    end
  end

  describe '#role1' do
    it 'exposes role 1' do
      expect(presenter.role1).to eq role1
    end
  end

  describe '#role2' do
    it 'exposes role 2' do
      expect(presenter.role2).to eq role2
    end
  end
end
