#!/usr/bin/env ruby

begin
  require 'bundler/setup'
rescue LoadError
  puts "❌ Bundler not found. Please install gems:"
  puts "   gem install bundler"
  puts "   bundle install"
  exit 1
end

begin
  require 'dotenv/load'
rescue LoadError
  puts "⚠️  Dotenv gem not found. Please run: bundle install"
  puts "   Continuing without environment file loading..."
end

require_relative 'lib/ruby_web_scraper_app'

# Load environment variables if dotenv is available
begin
  Dotenv.load if defined?(Dotenv)
rescue
  # Ignore if .env file doesn't exist
end

# Run the application
if __FILE__ == $0
  begin
    app = RubyWebScraperApp.new
    app.run
  rescue => e
    puts "❌ Error starting application: #{e.message}"
    puts "\n💡 Make sure you have:"
    puts "   1. Run 'bundle install' to install dependencies"
    puts "   2. Created a .env file with your API keys (copy from env.example)"
    puts "   3. Added your FIRECRAWL_API_KEY to the .env file"
    exit 1
  end
end
