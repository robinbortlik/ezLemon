class SitemapController < ApplicationController
  
  def index
    available_urls = ["root_url", "new_user_registration_path", "new_user_session_path", "about_project_path", "latest_activity_path", "wall_of_fame_path"]
    @urls = []
    ['cs', 'en'].each do |locale|
      available_urls.each do |url|
        @urls << "#{send(url, {:locale => locale, :only_path => false})}"
      end
    end
  end

end
