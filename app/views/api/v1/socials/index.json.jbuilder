# frozen_string_literal: true

json.social @socials do |s|
  json.id               s.id.to_s
  json.email            s.email
  json.location_ids     s.location_ids
  json.created_at       s.created_at.to_time.to_i if s.created_at
  json.updated_at       s.updated_at.to_time.to_i if s.updated_at
  json.google_id        s.google_id
  json.twitter_id       s.twitter_id
  json.facebook_id      s.facebook_id
  json.gender           s.gender
  json.current_location s.current_location
  json.first_name       s.first_name
  json.last_name        s.last_name
  json.checkins         s.checkins
  json.lonlat           s.lonlat
  json.fb_link          s.fb_link
  json.g_link           s.g_link

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
