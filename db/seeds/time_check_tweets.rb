# frozen_string_literal: true

user = User.create!(
  email: 'timecheck_user@example.com',
  name: 'Time Check User',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.zone.now,
  birthday: '1990-01-01',
  introduction: 'Hello, I am a time check user.',
  location: 'Tokyo',
  website: 'https://timecheck.com'
)

tweet_times = [
  5.minutes.ago.in_time_zone('Tokyo'),
  2.hours.ago.in_time_zone('Tokyo'),
  1.day.ago.in_time_zone('Tokyo')
]

3.times do |k|
  tweet_time = tweet_times[k]
  Tweet.create!(
    user:,
    body: "Time check tweet:#{k + 1}: " \
          "#{tweet_time.strftime('%Y/%m/%d %H:%M:%S')}",
    created_at: tweet_time
  )
end
