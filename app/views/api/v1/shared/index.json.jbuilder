# frozen_string_literal: true

json.message @errors || ['Error missing']
json.status 422
json.data yield
json.docs @docs
