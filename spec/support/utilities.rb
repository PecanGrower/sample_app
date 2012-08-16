def full_title(page_title)
	#Create a full title by combining a base title and the page title
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end