# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "foo"
  user.last_name             "bar"
  user.email                 "foo@mail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end
