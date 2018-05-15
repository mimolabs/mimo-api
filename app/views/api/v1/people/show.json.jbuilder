json.id @person.id.to_s
json.location_id @person.location_id
json.username @person.username
if @person.consented
  json.email @person.try(:email)
end
json.created_at @person.created_at.to_i
json.updated_at @person.updated_at.to_i
json.last_seen @person.last_seen.to_i
json.login_count @person.login_count
json.consented @person.consented

if @social.present?
  json.social do
    json.array! @social do |social|
      json.id social.id.to_s
      json.email social.email
      json.splash_ids social.splash_ids
      json.facebook_id social.facebookId
      json.created_at social.created_at.to_time.to_i
      json.updated_at social.updated_at.to_time.to_i
      json.client_macs social.clientMacs
      json.google_id social.googleId
      json.linkedin_id social.linkedinId
      json.gender social.gender
      json.current_location social.currentLocation
      json.first_name social.firstName
      json.last_name social.lastName
      json.checkins social.checkins
      json.fb_link social.fbLink
      json.li_link social.liLink
      json.g_link social.gLink
      json.li_headline social.liHeadline
      json.client_ids social.client_ids
      json.lonlat social.lonlat
      json.notes social.notes
      json.emails social.emails
      json.locations social.locations
      json.splash_ids social.splash_ids
      json.g_image_url social.gImageUrl
      json.g_full_name social.gFullName
      json.g_circled_by_count social.gCircledByCount
      json.g_organisations social.gOrganisations
      json.fb_current_location social.fbCurrentLocation
      json.li_current_location social.liCurrentLocation
    end
  end
end

if @guests.present?
  json.guests do
    json.array! @guests do |guest|
      json.id             guest.id.to_s
      json.username       guest.email
      json.registered     guest.registered
      json.created_at     guest.created_at.to_i
      json.codes          guest.radcheck_ids.try(:length)
      json.splash_page_id guest.splash_page_id
      json.macs           guest.macs
    end
  end
end

if @emails.present?
  json.emails do
    json.array! @emails do |email|
      json.id             email.id.to_s
      if email.consented
        json.email          email.email
      end
      json.created_at     email.created_at.to_i
      json.active         email.active
      json.comments       email.comments
      json.consented      email.consented
    end
  end
end

if @clients.present?
  json.clients do
    json.array! @clients do |client|
      json.id             client.id
      json.client_mac     client.client_mac
      json.ap_mac         client.ap_mac
      json.created_at     client.created_at.to_i
    end
  end
end

if @codes.present?
  json.codes do
    json.array! @codes do |code|
      json.id             code.id
      json.username       code.username_human
      json.created_at     code.created_at
    end
  end
end
