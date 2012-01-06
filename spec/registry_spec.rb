require 'spec_helper'

module Allowy
  describe Registry do
    let(:context) { 123 }
    subject       { Registry.new context }

    describe "#access_control_for!" do

      it "should find AC by appending Access to the subject" do
        subject.access_control_for!(Sample.new).should be_a SampleAccess
      end

      it "should find AC when the subject is a class" do
        subject.access_control_for!(Sample).should be_a SampleAccess
      end

      it "should raise when AC is not found by the subject" do
        expect { subject.access_control_for!(123) }.to raise_error UndefinedAccessControlError 
      end

      it "should raise when subject is nil" do
        expect { subject.access_control_for!(nil) }.to raise_error UndefinedAccessControlError 
      end

      it "should return the same AC instance" do
        first = subject.access_control_for!(Sample)
        secnd = subject.access_control_for!(Sample)
        first.should === secnd
      end

    end
  end
end
