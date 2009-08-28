require 'navigations'

Navigations::Repository.get(:main) do |nav|
  nav.page do |page|
    page.name = "Blog"
    page.link_to_eval = "articles_path"
  end

  nav.page_factory do
    Page.find(:all).map { |p| p.to_page }
  end

  nav.page do |page|
    # TODO this navigation should be made visible only if an admin is logged in.
    page.name = "All Pages"
    page.link_to_eval = "pages_path"
  end

  nav.cacheable = true
end