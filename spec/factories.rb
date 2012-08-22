FactoryGirl.define do
	factory :user do
		sequence(:name) 	{ |n| "Example Person-#{n+1}" }
		sequence(:email) 	{ |n| "person-#{n+1}@example.com"}
		password	"password"
		password_confirmation	"password"
	end
end
