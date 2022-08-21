require 'spec_helper'
require "#{$root}/lib/validators/base"
require "#{$root}/lib/validators/check_in"

RSpec.describe Validators::CheckIn do
    let(:validator) { described_class.new }

    describe '#valid?' do
        subject { validator.valid?(id, station_name, time) }
        
        let(:id) { 1 }
        let(:station_name) { 'Sevilla' }
        let(:time) { 2 }

        context 'when id is not an acceptable integer' do
            let(:id) { 'string' }

            it { expect(subject).to eq false }
        end

        context 'when station_name is not a string' do
            let(:station_name) { 1 }

            it { expect(subject).to eq false }
        end

        context 'when time is not an acceptable integer' do
            let(:time) { [] }

            it { expect(subject).to eq false }
        end

        context 'when user has existing checkin id' do
            subject { validator.valid?(id, station_name, time, 1) }

            it { expect(subject).to eq false }
        end

        it { expect(subject).to eq true }
    end
end
