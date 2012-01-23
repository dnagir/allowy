require 'spec_helper'

module Allowy
  class SampleContext
    include Context
  end

  describe Context do

    subject { SampleContext.new }
    let(:access) { stub }

    it "should create a registry" do
      Registry.should_receive(:new).with(subject)
      subject.current_allowy
    end

    it "should be able to check using can?" do
      subject.current_allowy.should_receive(:access_control_for!).with(123).and_return access
      access.should_receive(:can?).with(:edit, 123)
      subject.can?(:edit, 123)
    end

    it "should call authorize!" do
      access.should_receive(:authorize!).with :edit, 123
      subject.current_allowy.stub(:access_control_for! => access)
      subject.authorize! :edit, 123
    end
  end
end

