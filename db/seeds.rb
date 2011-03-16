################# LANGUAGES ########################
languages_codes = %w{LV BE MK AR KA RU BG PL HE MN VI RW SK MO SL HI AZ SO CA MS EL UZ MT JV FA
SQ EN SR EO KK PT BR KL CE NL BS TH LA KN LB ID SV KO ES SW TK HR ET ZH EU NO FI HU DA GA HY TR
FO JA AF KY DE CS FR UK IS SA IT RO LT}

languages_codes.sort{|a,b | a <=> b}.each do |code|
  Language.create(:code => code)
end

feed_urls = [
  {:url => "http://feeds.timesonline.co.uk/c/32313/f/463695/index.rss", :language_id => Language.where(:code => "EN").first.id},
  {:url => "http://servis.idnes.cz/rss.asp?c=sport", :language_id => Language.where(:code => "CS").first.id},
  {:url => "http://www.tvn24.pl/polska.xml", :language_id => Language.where(:code => "PL").first.id},
  {:url => "http://rss.dw-world.de/rdf/rss-de-cul", :language_id => Language.where(:code => "DE").first.id}
]

feed_urls.each do |feed_url|
  FeedUrl.create!(feed_url)
end


################## USERS ############################
u = User.new
u.email = "robinbortlik@gmail.com"
u.name = "Robin Bortlik"
u.avatar = File.open(File.join(Rails.root, "files/images/robin.jpg"))
u.password = "password"
u.password_confirmation = "password"
u.application_language_code = 'CS'
u.time_zone = "Prague"
u.is_admin = true
u.save

User.stamper = User.first

languages_codes.each do |code|
  Forum.create(:title => code, :language_id => Language.where(:code => code.to_s).first.id)
end
