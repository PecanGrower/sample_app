require 'spec_helper'

describe "User" do

	subject { page }

	valid_attributes = {
		name: "Example User",
		email: "user@example.com",
		password: "password",
		password_confirmation: "password"
	}

	describe "#new" do
		before { visit signup_path }
		
		it { should have_selector "h1", 		text: 'Sign up'}
		it { should have_selector "title", 	text: full_title('Sign up')}

		describe "form" do
			let(:submit) { "Create my account" }

			describe "with invalid information" do
				it "should not create a user" do
					expect { click_button submit }.not_to change(User, :count)
				end

			describe "after submission" do
				before { click_button submit }

				it { should have_selector "title",	text: 'Sign up' }
				it { should have_error_message }
				it { should_not have_error_message 'Password digest' }			
			end

			end

			describe "with valid information" do

				it "should create a user" do
					expect { signup(valid_attributes) }.to change(User, :count).by(1)
				end

				describe "after saving the user" do
					before { signup(valid_attributes) }
					let(:user) { User.find_by_email(valid_attributes[:email])}

					it { should have_selector 'title', text: user.name }
					it { should have_success_message 'Welcome' }
					it { should have_link 'Sign out', href: signout_path }
				end
			end
		end
	end

	describe "#show" do
		let (:user) { FactoryGirl.create(:user) }
		before { visit user_path(user)}

		it { should have_selector "h1",			text: "#{user.name}" }
		it { should have_selector "title",	text: full_title("#{user.name}") }
		it { should have_selector "img",		src: "gravatar.com/avatar/" }
	end

	describe "#edit" do
		let (:user) { FactoryGirl.create(:user) }
		before { visit edit_user_path(user) }

		it { should have_selector "title",	text: "Edit user" }
		it { should have_selector "h1",			text: "Update your profile" }
		it { should have_link			"change",	href: "http://gravatar.com/emails" }
		it { should have_selector "img",		src: "gravatar.com/avatar/" }

		describe "form" do
			let(:submit) { "Save changes" }
		
			describe "with invalid information" do
				before { click_button submit }

				it "?should not update user?"

				describe "after submission" do
					
					it { should have_selector "title", text: 'Edit user' }
					it { should have_error_message }
				end			
			end

			describe "with valid information" do
				before { update_user(user) }				
				
				it "?should update user?"

				describe "after submission" do

					it { should have_selector "title", text: "Updated Name" }
					it { should have_success_message }
					it { should have_link 'Sign out' }
					
				end
			end
		end
	end
end