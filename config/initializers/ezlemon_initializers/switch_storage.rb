module SwitchStorage
  def switch_storage(options = {})
    PAPERCLIP_STORAGE_OPTIONS.merge(options)
  end
end
ActiveRecord::Base.extend(SwitchStorage)

