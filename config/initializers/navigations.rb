require 'navigations'

Navigations::Repository.get(:main) do |nav|
  nav.page do |page|
    page.name = "Blog"
    page.link_to_eval = "articles_path"
    page.controller = ArticlesController
    page.check_path = true
  end

  nav.page_factory do
    Page.find(:all)
  end
end