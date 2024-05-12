# frozen_string_literal: true

User.create!(
  email: 'user@example.com',
  name: 'Example User',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.zone.now,
  birthday: '1990-01-01',
  introduction: 'Hello, I am an example user.',
  location: 'Tokyo',
  website: 'https://example.com'
)
