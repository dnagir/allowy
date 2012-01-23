require 'spec_helper'

module Allowy
  module Context
    extend ActiveSupport::Concern

    module InstanceMethods

      def allowy_context
        self
      end

      def current_allowy
        @current_allowy ||= ::Allowy::Registry.new(allowy_context)
      end

      def can?(action, subject, *args)
        current_allowy.access_control_for!(subject).can?(action, subject, *args)
      end

      def cannot?(*args)
        current_allowy.access_control_for!(subject).cannot?(action, subject, *args)
      end

      def authorize!(action, subject, *args)
        current_allowy.access_control_for!(subject).authorize!(action, subject, *args)
      end
    end
  end

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

