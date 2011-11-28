module TasksHelper
  def user_anchor(user)
    return '' if !user
    return "##{user.last_name}-#{user.id.to_s}"
  end

  def max_position(task)
    position = 1
    Task.transaction do
      position = task.maximum('position')
      if !position || position == ''
        position = 1
      else
        position = position + 1
      end
    end
    p "***"
    p "returning: " + position.to_s
    p "***"
    return position
  end
end
