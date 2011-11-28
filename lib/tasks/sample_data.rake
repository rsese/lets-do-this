namespace :db do

  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    admin = User.create!(:first_name => "Foo",
                         :last_name => "Bar",
                         :email => "foo@mail.com",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
    15.times do |n|
      first_name = Faker::Name.name.split[0]
      last_name = Faker::Name.name.split[1]
      email = "example-#{n + 1}@mail.com"
      password = "password"
      User.create!(:first_name => first_name,
                   :last_name => last_name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    User.all(:limit => 10).each do |user|
      3.times do
        assigned_to = rand(User.all.count) + 1
        t = user.created_tasks.create!(:description => Faker::Lorem.sentence(5),
                                       :assigned_to_id => assigned_to)
        position = Task.where(:assigned_to_id => assigned_to).maximum('position')
        p "#{User.find(assigned_to).first_name} - task position: '#{position}'"
        if !position || position == ''
          t.position = 1
        else
          t.position = position + 1
        end
        p "#{User.find(assigned_to).first_name}: task position set to: #{t.position}"
        t.save
      end
    end
  end
end

