require 'pry'
require 'allowy'
require 'allowy/matchers'

module Allowy

  class Page
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

  class PageAccess
    include AccessControl
    context :current_user, :whatever

    def read?(page)
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
      expect { subject.can? :write, page_for('allow') }.to raise_error UndefinedActionError
    end

  end

end
