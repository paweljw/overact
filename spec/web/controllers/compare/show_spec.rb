RSpec.describe Web::Controllers::Compare::Show, type: :action do
  include Rack::Test::Methods

  let(:app) { Hanami.app }
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  context 'with bad params' do
    it 'shows error' do
      get '/compare/asdf/ghij'
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "This doesn't look like anything to me"
    end
  end

  context 'with valid params' do
    let(:action) { described_class.new(movie_enqueuer: movie_enqueuer, overlap_finder: overlap_finder) }
    let(:movie_enqueuer) { instance_double('MovieEnqueuer') }
    let(:overlap_finder) { instance_double('OverlapFinder') }
    let(:movie_result1) { double(movie: movie1) }
    let(:movie_result2) { double(movie: movie2) }
    let(:movie1) { instance_double('Movie', checked?: false) }
    let(:movie2) { instance_double('Movie', checked?: false) }

    context 'when movies not ready' do
      it 'exposes movies' do
        expect(movie_enqueuer).to receive(:call).with(tt_id: 'tt123').and_return(movie_result1)
        expect(movie_enqueuer).to receive(:call).with(tt_id: 'tt456').and_return(movie_result2)
        expect(overlap_finder).to_not receive(:call)

        response = action.call(movie1: 'tt123', movie2: 'tt456')
        expect(action.exposures[:movie1]).to eq movie1
        expect(action.exposures[:movie2]).to eq movie2
      end
    end

    context 'when movies ready' do
      let(:movie1) { instance_double('Movie', checked?: true, id: 'tt123') }
      let(:movie2) { instance_double('Movie', checked?: true, id: 'tt456') }
      let(:overlap) { double }
      let(:overlap_result) { double(overlap: overlap) }

      it 'exposes overlap' do
        expect(movie_enqueuer).to receive(:call).with(tt_id: 'tt123').and_return(movie_result1)
        expect(movie_enqueuer).to receive(:call).with(tt_id: 'tt456').and_return(movie_result2)
        expect(overlap_finder).to receive(:call).with(movie1_id: 'tt123', movie2_id: 'tt456').and_return(overlap_result)

        response = action.call(movie1: 'tt123', movie2: 'tt456')
        expect(action.exposures[:overlapping_roles]).to eq overlap
      end
    end
  end
end
