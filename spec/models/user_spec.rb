require 'spec_helper'

describe User do
  let (:user) { Factory.build(:user) }

  describe "twitter handle" do
    it "strips a prefixed @-symbol" do
      user.twitter = "@Lenary"
      user.twitter.should == "Lenary"
    end

    it "copes with no prefixed @-symbol" do
      user.twitter = "Lenary"
      user.twitter.should == "Lenary"
    end
  end

  context "#fulltext_search" do
    before do
      @user1 = Factory(:user, :interests => "foo, bar, baz", :name => "Mandrelbot")
      @user2 = Factory(:user, :interests => "fu, bar, buzz")
    end
    
    it "should allow to search by term" do
      User.fulltext_search("buzz").should == [@user2]
    end

    it "should not bring back results for 2 char queries" do
      User.fulltext_search("fu").should == []
    end

    it "should search across searchable fiels (interests and name in this case)" do
      User.fulltext_search("foo").should == [@user2, @user1]
    end

    it "should allow for maximum results" do
      User.fulltext_search("foo", {:max_results => 1}).should == [@user2]
    end
    
  end
  
end
