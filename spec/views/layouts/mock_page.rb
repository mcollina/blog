
def mock_page(hash)
  page = mock "Page #{hash[:name]}"
  page.should_receive(:visible?).and_return(hash[:visible])
  if hash[:visible]
    page.should_receive(:name).and_return(hash[:name]) if hash.has_key? :name
    page.should_receive(:current?).at_most(1).and_return(hash[:current]) if hash.has_key? :current
    if hash.has_key? :link
      page.should_receive(:link).and_return(hash[:link])
      link_options = hash[:link_options]
      link_options ||= {}
      page.should_receive(:link_options).and_return(link_options)
    end
  end
  page
end
