json.id         user.id
json.email      user.email
json.first_name user.first_name
json.last_name  user.last_name
json.gender     user.gender
json.avatar     user.avatar.attached? ? polymorphic_url(user.avatar) : nil
