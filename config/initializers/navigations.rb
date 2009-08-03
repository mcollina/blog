require 'navigations'

Navigations::Repository.get(:main) do |nav|
  nav.page do |page|
    page.name = "Blog"
    page.link_to_eval = "articles_path"
  end

  nav.page_factory do
    Page.find(:all)
  end

  nav.page do |page|
    # TODO this navigation should be made visible only if an admin is logged in.
    page.name = "New Page"
    page.link_to_eval = "new_page_path"
  end
end