require 'spec_helper'

describe "User" do

	subject { page }

	let(:valid_user) { FactoryGirl.build(:user) }

	describe "#index" do
		let(:user) { FactoryGirl.create(:user) }
		
		
		before(:each) do
			signin(user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
			visit users_path
		end
		
		describe "page" do
			
			it { should have_selector "title", 	text: "Users" }
			it { should have_selector "h1",			text: "All users" }

			describe "pagination" do
				before(:all) 	{ 30.times { FactoryGirl.create(:user) } }
				after(:all) 	{ User.delete_all }


				it { should have_selector "div.pagination" }
				
				it "should display all users" do
					User.paginate(page: 1).each do |user|
						should have_link user.name, href: user_path(user)
					end
				end
			end

			describe "delete links" do

	      it { should_not have_link('delete') }

	      describe "as an admin user" do
	        let(:admin) { FactoryGirl.create(:admin) }
	        before do
	          signin admin
	          visit users_path
	        end

	        it { should have_link('delete', href: user_path(User.first)) }
	        it "should be able to delete another user" do
	          expect { click_link('delete') }.to change(User, :count).by(-1)
	        end
	        it { should_not have_link('delete', href: user_path(admin)) }

	        describe "after deleting user" do
	        	before { click_link "delete" }	        	
	        	it { should have_success_message }
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
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
		before { visit user_path(user)}

		describe "page" do

			it { should have_selector "h1",			text: "#{user.name}" }
			it { should have_selector "title",	text: full_title("#{user.name}") }
			it { should have_selector "img",		src: "gravatar.com/avatar/" }

			describe "microposts" do
				it { should have_content(m1.content) }
				it { should have_content(m2.content) }
				it { should have_content(user.microposts.count) }

	      describe "pagination" do
	        before(:all) { 30.times { FactoryGirl.create(:micropost, user: user) } }
	        after(:all)  { User.delete_all }

	        it { should have_selector "div.pagination" }
	        it "should display all microposts" do
	          user.microposts.paginate(page: 1).each do |micropost|
	            page.should have_selector("li", text: micropost.content)
	          end
	        end
	      end
			end
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
			specify { find_link('change')[:target].should == '_blank'}
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

	describe "#delete" do
		
	end

	describe "#following" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			user.follow!(other_user)
			signin user
			visit following_user_path(user)
		end

		it { should have_selector('title', text: full_title('Following')) }
		it { should have_selector('h3'), text: 'Following' }
		it { should have_link(other_user.name, href: user_path(other_user)) }
	end

	describe "#followers" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			user.follow!(other_user)
			signin other_user
			visit followers_user_path(other_user)
		end
		it { should have_selector('title', text: full_title('Followers')) }
		it { should have_selector('h3'), text: 'Followers' }
		it { should have_link(user.name, href: user_path(user)) }
		
	end
end