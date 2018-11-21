require_relative '../spec/spec_helper'

RSpec.describe GeomCheck do
  describe 'slope' do
    it 'checks angle from two points' do
      expect(GeomCheck.new.slope([1,2],[3,4])).to eq(1.0)
    end
  end
end
