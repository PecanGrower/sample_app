include ApplicationHelper

def signin(user)
  visit signin_path
  fill_in "Email", 		with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def complete_signup_form(user)
  fill_in "Name",					with: user.name
  fill_in "Email",				with: user.email
  fill_in "Password",			with: user.password
  fill_in "Confirmation",	with: user.password_confirmation
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