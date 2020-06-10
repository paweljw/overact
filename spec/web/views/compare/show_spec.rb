# frozen_string_literal: true

RSpec.describe Web::Views::Compare::Show, type: :view do
  let(:exposures) { Hash[format: :html, overlapping_roles: overlapping_roles, movie1: movie1, movie2: movie2] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/compare/show.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:overlapping_roles) { [[double, double, double]] }
  let(:movie1) { double(checked?: true) }
  let(:movie2) { double(checked?: true) }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it 'builds presentable overlaps' do
    expect(view.overlap).to be_an(Array)
    expect(view.overlap.count).to eq 1
    expect(view.overlap.first).to be_an(Web::OverlapPresenter)
  end

  describe '#movies_ready?' do
    context 'when both movies checked' do
      it { expect(view.movies_ready?).to be_truthy }
    end

    context 'when at least one movie not checked' do
      let(:movie2) { double(checked?: false) }

      it { expect(view.movies_ready?).to be_falsey }
    end
  end
end
