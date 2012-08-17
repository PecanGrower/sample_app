require 'spec_helper'

describe ApplicationHelper do

	describe "full_title" do

		subject { full_title('foo') }

		it { should =~ /\| foo/ }
		it { should =~ /^Ruby on Rails Tutorial Sample App/ }
		it { full_title("").should_not =~ /\|/ } #No bar for untitled pages		
	end	
end