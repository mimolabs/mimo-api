# frozen_string_literal: true

json.id @audience.id.to_s
json.created_at @audience.created_at.to_i
json.updated_at @audience.updated_at.to_i
json.name @audience.name
json.predicates @audience.predicates
json.predicate_type @audience.predicate_type
json.location_id @audience.location_id
