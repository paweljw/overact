# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Web::Views::ApplicationLayout, type: :view do
  let(:layout)   { Web::Views::ApplicationLayout.new({ format: :html }, 'contents') }
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('Overact')
    expect(rendered).to include('Built with ❤ by Paweł J. Wal')
  end
end
