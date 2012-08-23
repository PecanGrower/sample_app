require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }
		it { should have_selector 'title',	text: 'Sign in' }
		it { should have_selector 'h1',		 	text: 'Sign in'}
		it { should have_link 'Sign up now!', href: signup_path }
	end
	
	describe "signin form" do
		let (:user) { FactoryGirl.create(:user)}
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }
			it { should have_selector 'title', text: 'Sign in' }
			it { should have_error_message }

			describe "after visiting another page" do
				before { click_link 'Home' }
				it { should_not have_error_message }
			end
		end

		describe "with valid information" do
			before { signin(user) }
			it { should have_selector 'title', text: user.name }

			it { should have_link 'Users', 		href: users_path }
			it { should have_link 'Profile', 	href: user_path(user) }
			it { should have_link 'Settings', href: edit_user_path(user) }
			it { should have_link 'Sign out', href: signout_path }
			it { should_not have_link 'Sign in', href: signin_path }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link 'Sign in', href: signin_path }
			end
		end
	end

	describe "authorization" do
		let(:user) { FactoryGirl.create(:user) }
		
		describe "for non-signed-in users" do

			describe "in the Users controller" do

				describe "visiting the index page" do
					before { visit users_path }
					it { should have_selector "title", text: "Sign in" }
					it { should have_notice_message }
				end
				
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }					
					it { should have_selector "title", text: "Sign in" }
					it { should have_notice_message }

					describe "then signing in" do
						before { signin(user) }
						it { should have_selector "title", text: "Edit user" }
					end
				end

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path)}
				end
			end
		end

		describe "for wrong user" do
			let(:wrong_user) { FactoryGirl.create(:user) }
			before { signin user }
			
			describe "in the Users controller" do
				
				describe "visiting the edit page" do
					before { visit edit_user_path(wrong_user) }
					it { should have_selector 'h1', text: "Sample App" }
				end

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(wrong_user) }
					specify { response.should redirect_to(root_path) }
				end
			end
		end

		describe "for non-admins" do
			let(:non_admin) { FactoryGirl.create(:user) }

			before { signin user }
			
			describe "in the Users controller" do
				
				describe "submitting a DELETE request to the Users#destroy action" do
					before { delete user_path(user) }
					specify { response.should redirect_to(root_path) }
				end
			end
		end
	end
end