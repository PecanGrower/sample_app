include ApplicationHelper

def signin(user)
  visit signin_path
  fill_in "Email", 		with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  #Sign in when not using Capybara as well
  cookies[:remember_token] = user.remember_token
end

def signup(user)
  visit signup_path
  fill_in "Name",					with: user.name
  fill_in "Email",				with: user.email
  fill_in "Password",			with: user.password
  fill_in "Confirmation",	with: user.password_confirmation
  click_button "Create my account"
end

def update_user(user)
  visit edit_user_path(user)
  fill_in "Name",         with: "Updated Name"
  fill_in "Email",        with: "updated_email@example.com"
  fill_in "Password",     with: user.password
  fill_in "Confirm Password", with: user.password
  click_button "Save changes"
end


RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert-success', text: message)
  end
end