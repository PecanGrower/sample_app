require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "session#new" do

		describe "page" do
			before { visit signin_path }
			it { should have_selector 'title',	text: 'Sign in' }
			it { should have_selector 'h1',		 	text: 'Sign in'}
			it { should have_link 'Sign up now!', href: signup_path }
		end
		describe "form" do
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
				it { should_not have_link 'Sign in' }

				describe "followed by signout" do
					before { click_link "Sign out" }
					it { should have_link 'Sign in', href: signin_path }
					it { should_not have_link 'Profile' }
					it { should_not have_link 'Settings' }
				end
			end
		end
	end
	
	describe "authorization" do
		let(:user) { FactoryGirl.create(:user) }

		describe "for signed-in users" do
			before { signin user }
			
			describe "in the Users controller" do
				
				describe "visiting the new page" do
					before { get new_user_path }
					specify { response.should redirect_to(root_path) }
					
				end

				describe "submitting a POST request to the Users#create action" do
					before { post users_path }
					specify { response.should redirect_to(root_path)}
				end
			end
		end
		
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

						describe "then subsequently signing in" do
							before do
							  sign_out
							  visit root_path
							  signin(user)
							end

							it { should have_selector "title", text: user.name }
						end
					end
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path)}
				end				
			end

			describe "in the Microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { response.should redirect_to(signin_path) }
				end
				
			end
		end

		describe "for wrong user" do
			let(:wrong_user) { FactoryGirl.create(:user) }
			before { signin user }
			
			describe "in the Users controller" do
				
				describe "visiting the edit page" do
					before { get edit_user_path(wrong_user) }
					specify { response.should redirect_to(root_path) }
				end

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(wrong_user) }
					specify { response.should redirect_to(root_path) }
				end
			end
		end

		describe "for non-admins" do
			let(:non_admin) { FactoryGirl.create(:user) }

			before { signin non_admin }
			
			describe "in the Users controller" do
				
				describe "submitting a DELETE request to the Users#destroy action" do
					before { delete user_path(user) }
					specify { response.should redirect_to(root_path) }
				end
			end
		end

		describe "for admins" do
			let(:admin) { FactoryGirl.create(:admin) }

			before { signin admin }

			describe "in the Users controller" do

				describe "submitting a DELETE request for self" do
					
					it "should not delete self" do
						expect { delete user_path(admin) }.to change(User, :count).by(0)
					end

				end
			end
		end
	end
end