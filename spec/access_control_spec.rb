require 'spec_helper'

module Allowy
  describe "checking permissions" do

    let(:access)  { SampleAccess.new(123) }
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
      subject.should be_able_to :read, 'allow'
    end

    it "should deny" do
      subject.should_not be_able_to :read, 'deny'
    end

    it "should raise if no permission defined" do
      expect { subject.can? :write, 'allow' }.to raise_error UndefinedActionError
    end


    describe "#authorize!" do
      it "shuold raise error" do
        expect { subject.authorize! :read, 'deny' }.to raise_error AccessDenied
      end
      it "should not raise error" do
        expect { subject.authorize! :read, 'allow' }.not_to raise_error AccessDenied
      end
    end

  end

end
