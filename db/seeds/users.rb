# frozen_string_literal: true

users = []

5.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    name: "Example User #{i + 1}",
    password: "password#{i + 1}",
    password_confirmation: "password#{i + 1}",
    confirmed_at: Time.zone.now,
    birthday: "199#{i}-01-01",
    introduction: "Hello, I am example user #{i + 1}.",
    location: 'Tokyo',
    website: "https://example#{i + 1}.com"
  )

  tweets = []

  10.times do |j|
    tweet = Tweet.create!(
      user:,
      body: "User#{i + 1} Seed Tweet #{j + 1}"
    )
    tweets << tweet
  end

  users << { user:, last_tweet: tweets.last }
end

users.each do |user|
  users.each do |target_data|
    5.times do |k|
      comment = Comment.create!(
        user: user[:user],
        tweet: target_data[:last_tweet],
        body: "Comment #{k + 1} by #{user[:user].name} on #{target_data[:last_tweet].body}"
      )

      comment.create_notification(user[:user])
    end
  end

  next if user[:user] == users.first[:user]

  Group.create!(
    sender: user[:user],
    recipient: users.first[:user]
  )

  follow = Follow.create!(follower: user[:user], followed: users.first[:user])
  follow.create_notification(user[:user])

  favorite = Favorite.create!(user: user[:user], tweet: users.first[:last_tweet])
  favorite.create_notification(user[:user])
end
