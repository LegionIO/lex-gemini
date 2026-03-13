# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini do
  it 'has a version number' do
    expect(Legion::Extensions::Gemini::VERSION).not_to be_nil
  end

  it 'has a version string' do
    expect(Legion::Extensions::Gemini::VERSION).to be_a(String)
  end
end
