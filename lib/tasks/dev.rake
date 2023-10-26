desc "Fill the database tables with some sample data"
# task({ :sample_data => :environment }) do
# end

task sample_data: :environment do
  p "Creating sample data"
  starting = Time.now

  if Rails.env.development?
    FollowRequest.delete_all
    Comment.delete_all
    Like.delete_all
    Photo.delete_all
    User.delete_all
  end

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
  end

  12.times do
    name = Faker::Name.first_name
    u = User.create(
      email: "#{name}@example.com",
      password: "password",
      private: [true, false].sample,
    )
    # p u.errors.full_messages
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample,
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample,
        )
      end
    end

    rand(15).times do
      photo = first_user.own_photos.create(
        caption: Faker::Quote.jack_handey,
        image: "https://robohash.org/#{rand(9999)}"
      )
    
      first_user.followers.each do |follower|
        if rand < 0.5
          photo.fans << follower
        end

        if rand < 0.25
          Comment.create(
            photo: photo,
            body: Faker::Quote.jack_handey,
            author: follower
          )
        end
      end
    end
  end
  
  p "There are now #{User.count} users."
  p "There are now #{FollowRequest.count} follow requests."
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
