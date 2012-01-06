require 'spec_helper'

module Allowy

  class Page
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

  class PageAccess
    include AccessControl

    def read?(page)
      page.name == 'allow'
    end

    def context_is_123?(*whatever)
      context === 123
    end
  end

  describe "checking permissions" do

    def page_for(name)
      Page.new(name)
    end

    let(:access)  { PageAccess.new(123) }
    subject       { access }

    describe "#context as an arbitrary object" do
      subject     { access.context }
      its(:to_s)  { should == '123' }
      its(:zero?) { should be_false }
      it "should be able to access the context" do
        access.should be_able_to :context_is_123
      end
    end

    it "should allow" do
      subject.should be_able_to :read, page_for('allow')
    end

    it "should deny" do
      subject.should_not be_able_to :read, page_for('deny')
    end

    it "should raise if no permission defined" do
      expect { subject.can? :write, page_for('allow') }.to raise_error UndefinedActionError
    end


    describe "#authorize!" do
      it "shuold raise error"
      it "should not raise error"
    end

  end

end
