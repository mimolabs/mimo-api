json.message @errors || ['Error missing']
json.status 422
json.data yield
json.docs @docs
