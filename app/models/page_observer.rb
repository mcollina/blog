class PageObserver < ActiveRecord::Observer

  def after_save(page)
    Navigations::Repository.get(:main).invalidate_cache
  end

  alias :after_destroy :after_save
end
