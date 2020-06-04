require 'spec_helper'

RSpec.describe MovieSyncWorker do
  let(:movie_repo) { instance_double('MovieRepository') }
  let(:movie_scraper) { double('MovieScraper') }
  let(:pair_upserter) { instance_double('ScrapedPairUpserter') }

  context 'when movie not present' do
    it 'bails immediately' do
      expect(movie_repo).to receive(:find_by_tt).and_return(nil)
      expect(movie_scraper).to_not receive(:new)

      described_class.new.perform(123, movie_repo: movie_repo, movie_scraper: movie_scraper, pair_upserter: pair_upserter)
    end
  end

  context 'when movie already checked' do
    let(:movie) { double(checked?: true) }

    it 'bails immediately' do
      expect(movie_repo).to receive(:find_by_tt).and_return(movie)
      expect(movie_scraper).to_not receive(:new)

      described_class.new.perform(123, movie_repo: movie_repo, movie_scraper: movie_scraper, pair_upserter: pair_upserter)
    end
  end

  context 'when movie not checked' do
    let(:movie) { double(checked?: false, id: 12) }
    let(:scraped_pair) { double }
    let(:scraper) { double(actors: [scraped_pair], movie_name: 'boom') }

    it 'bails immediately' do
      expect(movie_repo).to receive(:find_by_tt).and_return(movie)
      expect(movie_scraper).to receive(:new).with(tt_id: 123).and_return(scraper)
      expect(pair_upserter).to receive(:call).with(movie_id: 12, scraped_pair: scraped_pair)
      expect(movie_repo).to receive(:update).with(12, { name: 'boom', status: 'checked' })

      described_class.new.perform(123, movie_repo: movie_repo, movie_scraper: movie_scraper, pair_upserter: pair_upserter)
    end
  end
end
