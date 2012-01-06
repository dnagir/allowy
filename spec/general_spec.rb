require 'pry'
require 'active_support/concern'

module Allowy

  class AbleToMatcher
    def initialize(action, subject)
      @action, @subject = action, subject
    end

    def say msg
      "#{msg} #{@action} #{@subject.inspect}" + if @context && @context.any?
        @context.inspect
      else
        ''
      end
    end

    def ==(access_control)
      @context = access_control.context
      access_control.can?(@action, @subject)
    end

    def description
      say "be able to"
    end

    def failure_message_for_should
      say "expected to be able to"
    end

    def failure_message_for_should_not
      say "expected NOT to be able to"
    end

  end
  module ::Kernel
    def able_to?(action, subject)
      AbleToMatcher.new(action, subject)
    end
  end

  module AccessControl
    extend ActiveSupport::Concern

    module ClassMethods
      def context(*accessors)
        accessors.each do |m|
          attr_accessor m
        end
      end
    end

    module InstanceMethods
      def initialize(context={})
        prepare_context(context)
      end

      def prepare_context(context={})
        context.each_pair do |k,v|
          self.send("#{k}=", v)
        end
        self
      end

      def can?(action, subject, *args)
      end

      def cannot?(action, subject, *args)
        !can?(action, subject, *args)
      end

    end

  end

  class Page
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

  class PageAccess
    include AccessControl
    context :current_user, :whatever

    def read(page)
      page.name == 'allow'
    end
  end

  describe "checking permissions" do

    def page_for(name)
      Page.new(name)
    end

    subject { PageAccess.new(:current_user => 123, :whatever => 456) }

    its(:current_user)  { should == 123 }
    its(:whatever)      { should == 456 }

    it "should allow" do
      subject.should be_able_to :read, page_for('allow')
    end

    it "should deny" do
      subject.should_not be_able_to :read, page_for('deny')
    end


    it "should raise if no permission defined" do
      expect { subject.can? :write, page_for('allow') }.to raise_error UndefinedPermission
    end

    it "should allow on class" do
      subject.should be_able_to :read_for_all, Page
    end

    it "should not allow on class" do
      subject.should_not be_able_to :read_private, Page
    end

  end

end
