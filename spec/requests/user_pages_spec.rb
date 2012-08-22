require 'spec_helper'

describe "User" do

	subject { page }

	let(:valid_user) { FactoryGirl.build(:user) }

	describe "#index" do
		let(:user) { FactoryGirl.create(:user) }
		
		before(:all) { 30.times { FactoryGirl.create(:user) } }
		after(:all) { User.delete_all }
		
		before(:each) do
			signin(user)
			visit users_path
		end
		
		describe "page" do
			
			it { should have_selector "title", 	text: "Users" }
			it { should have_selector "h1",			text: "All users" }

			describe "pagination" do

				it { should have_selector "div.pagination" }
				it "should display all users" do
					User.paginate(page: 1).each do |user|
						should have_link user.name, href: user_path(user)
						should have_selector "ul.users"
					end
				end
			end
		end
	end

	describe "#new" do
		before { visit signup_path }

		describe "page" do
		
			it { should have_selector "h1", 		text: 'Sign up'}
			it { should have_selector "title", 	text: full_title('Sign up')}
		end

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
					expect { signup(valid_user) }.to change(User, :count).by(1)
				end

				describe "after saving the user" do
					before { signup(valid_user) }
					let(:user) { User.find_by_email(valid_user.email)}

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

		describe "page" do

			it { should have_selector "h1",			text: "#{user.name}" }
			it { should have_selector "title",	text: full_title("#{user.name}") }
			it { should have_selector "img",		src: "gravatar.com/avatar/" }
		end
	end

	describe "#edit" do
		let (:user) { FactoryGirl.create(:user) }
		before do
			signin(user)
			visit edit_user_path(user)
		end

		describe "page" do
			
			it { should have_selector "title",	text: "Edit user" }
			it { should have_selector "h1",			text: "Update your profile" }
			it { should have_link			"change",	href: "http://gravatar.com/emails" }
			it { should have_selector "img",		src: "gravatar.com/avatar/" }
		end

		describe "form" do
			let(:submit) { "Save changes" }
		
			describe "with invalid information" do
				before { click_button submit }

				specify { user.name.should 	== user.reload.name }
				specify { user.email.should == user.reload.email }

				describe "after submission" do
					
					it { should have_selector "title", text: 'Edit user' }
					it { should have_error_message }
				end			
			end

			describe "with valid information" do
				before { update_user(user) }

				specify { user.reload.name.should 	== "Updated Name" }
				specify { user.reload.email.should 	== "updated_email@example.com"}
				

				describe "after submission" do

					it { should have_selector "title", text: "Updated Name" }
					it { should have_success_message }
					it { should have_link 'Sign out' }
					
				end
			end
		end
	end
end