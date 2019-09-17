json.array! @users do |user|
  json.user do
    json.partial! 'info', user: user
  end
end
