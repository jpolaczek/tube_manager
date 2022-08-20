require 'spec_helper'
require "#{$root}/lib/validators/base"
require "#{$root}/lib/validators/check_in"

RSpec.describe Validators::CheckIn do
    let(:validator) { described_class.new }

    describe '#call!' do
        subject { validator.call!(id, station_name, time) }
        let(:id) { 1 }
        let(:station_name) { 'Sevilla' }
        let(:time) { 2 }

        context 'when id is not an acceptable integer' do
            let(:id) { 'string' }

            it { expect { subject }.to raise_error(Validators::CheckIn::CheckInValidationError) }
        end

        context 'when station_name is not a string' do
            let(:station_name) { 1 }

            it { expect { subject }.to raise_error(Validators::CheckIn::CheckInValidationError) }
        end

        context 'when time is not an acceptable integer' do
            let(:time) { [] }

            it { expect { subject }.to raise_error(Validators::CheckIn::CheckInValidationError) }
        end

        it { expect { subject }.to_not raise_error }
    end
end
