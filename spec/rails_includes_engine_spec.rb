require "spec_helper"

RSpec.describe RailsIncludesEngine do
  it "has a version number" do
    expect(RailsIncludesEngine::VERSION).not_to be nil
  end

  it "parses the right number of segments" do
    ie = RailsIncludesEngine::IncludesEngine.new "a{b{c}}"
    ih = ie.includes_hash simple: true
    expect(ih.length).to be 1
  end

  it "generates correct simple hash" do
    ie = RailsIncludesEngine::IncludesEngine.new "a{b{c}}"
    ih = ie.includes_hash simple: true
    segment = ih.first
    expect(segment).to match({
      a: [
        {
          b: [
            :c
          ]
        } 
      ]
    })
  end
end
