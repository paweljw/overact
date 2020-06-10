# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RoleUpserter do
  let(:role_repo) { instance_double('RoleRepository') }
  let(:interactor) { described_class.new(role_repo: role_repo) }
  let(:role) { double }

  context 'when role already existed' do
    it 'returns the role' do
      expect(role_repo).to receive(:find_by_movie_and_actor).and_return(role)
      expect(role_repo).to_not receive(:create)

      expect(interactor.call({}).role).to eq role
    end
  end

  context 'when role did not previously exist' do
    it 'creates and returns the role' do
      expect(role_repo).to receive(:find_by_movie_and_actor).and_return(nil)
      expect(role_repo).to receive(:create).with({}).and_return(role)

      expect(interactor.call({}).role).to eq role
    end
  end
end
