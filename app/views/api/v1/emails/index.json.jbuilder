# frozen_string_literal: true

json.emails do
  json.array! @emails do |e|
    json.id             e.id.to_s
    json.created_at     e.created_at.to_time.to_i
    json.added          e.added
    json.list_id        e.list_id
    json.splash_id      e.splash_id
    json.location_id    e.location_id
    json.list_id        e.list_id
    json.list_type      e.list_type
    json.email e.email if e.consented
    json.station_id     e.station_id
    json.active         e.active
    json.unsubscribed   e.unsubscribed
    json.consented      e.consented
  end
end

json.locations do
  json.array! @locations do |l|
    json.id             l.id
    json.location_name  l.location_name
  end
end

json._links do
  json.current_page       @emails.try(:current_page) || 1
  json.total_pages        @emails.try(:total_pages) || 0
  json.next_page          @emails.try(:next_page)
  json.total_entries      @emails.try(:total_count) || 0
  json.start              params[:start]
  json.end                params[:end]
end
