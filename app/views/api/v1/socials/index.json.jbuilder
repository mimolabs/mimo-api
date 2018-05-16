# if params[:q].present? #|| params[:email].present?
#   json.results            @results
# else
json.social @socials do |s|
  json.id               s.id.to_s
  json.email            s.email
  json.location_ids     s.location_ids
  json.created_at       s.created_at.to_time.to_i if s.created_at
  json.updated_at       s.updated_at.to_time.to_i if s.updated_at
  json.googleId         s.googleId
  json.linkedinId       s.linkedinId
  json.facebookId       s.facebookId

  json.google_id        s.googleId
  json.linkedin_id      s.linkedinId
  json.facebook_id      s.facebookId

  json.gender           s.gender
  json.currentLocation  s.currentLocation

  json.firstName        s.firstName
  json.lastName         s.lastName

  json.first_name       s.firstName
  json.last_name        s.lastName

  json.checkins         s.checkins
  json.linkedin         "linkedin" if s.linkedinId
  json.google           "google" if s.googleId
  json.facebook         "facebook" if s.facebookId
  json.lonlat           s.lonlat
  json.fb_link          s.fbLink
  json.g_link           s.gLink

  json.twitter_id       s.twitter_id
  json.tw_full_name     s.tw_full_name
  json.tw_screen_name   s.tw_screen_name
  json.tw_description   s.tw_description
  json.tw_url           s.tw_url
  json.tw_verified      s.tw_verified
  json.tw_followers     s.tw_followers
  json.tw_friends       s.tw_friends
  json.tw_profile_image s.tw_profile_image
end

json._links do
  json.current_page     @socials.try(:current_page) || 1
  json.total_pages      @socials.try(:total_pages) || 0
  json.next_page        @socials.try(:next_page) || 0
  json.total_entries    @total || 0
  json.start            params[:start]
  json.end              params[:end]
end
# end
