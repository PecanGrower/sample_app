require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }

  before do
  	@micropost = user.microposts.new(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to :content }
  it { should respond_to :user }

  it { should be_valid }

  describe "accessible attributes" do
  	
  	it "should not allow access to user_id" do
  		expect do
  			Micropost.new(user_id: 1)
  		end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "validations for" do
  	
  	describe "content:" do
  		
  		describe "when not present" do
  			before { @micropost.content = "" }
  			it { should_not be_valid }
  		end

  		describe "when too long" do
  			before { @micropost.content = "a" * 141 }
  			it { should_not be_valid }
  		end
  	end
  end

  describe "order" do
		let!(:old_micropost) do
			FactoryGirl.create(:micropost, 	content: "Oldest post", user: user,
																			created_at: 1.day.ago )
		end 
		let!(:new_micropost) do
			FactoryGirl.create(:micropost, 	content: "Newest post", user: user,
																			created_at: 1.hour.ago )
		end
		before { @microposts = Micropost.all }

  	it "should be DESC by created_at" do
  		@microposts.should == [new_micropost, old_micropost]
  	end
  	
  end

end
