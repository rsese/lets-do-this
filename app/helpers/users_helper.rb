module UsersHelper
  def name(user)
    return '' if !user
    return "#{user.first_name} #{user.last_name}"
  end
end
