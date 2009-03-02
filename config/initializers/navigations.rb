require 'navigations'

Navigations::Repository.get(:main) do |nav|
  nav.page do |page|
    page.name = "Blog"
    page.link_to_eval = "articles_path"
    page.controller = ArticlesController
  end
end