namespace :api do
  desc "Generate a new API key"
  task generate_key: :environment do
    token = SecureRandom.hex(20)
    ApiKey.create!(token: token, name: "Admin")
    puts "API KEY: #{token}"
  end
end
