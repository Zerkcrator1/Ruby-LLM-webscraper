#!/usr/bin/env ruby

puts "🚀 RUBYLLM Setup Script"
puts "======================"

# Check if Bundler is installed
print "Checking for Bundler... "
begin
  require 'bundler'
  puts "✅ Found"
rescue LoadError
  puts "❌ Missing"
  puts "\nInstalling Bundler..."
  system("gem install bundler")
end

# Check if gems are installed
print "Checking gems... "
if File.exist?('Gemfile.lock')
  puts "✅ Already installed"
else
  puts "❌ Need to install"
  puts "\nInstalling gems..."
  system("bundle install")
end

# Check for environment file
print "Checking environment file... "
if File.exist?('.env')
  puts "✅ Found"
else
  puts "❌ Missing"
  puts "\nCreating .env file from template..."
  if File.exist?('env.example')
    require 'fileutils'
    FileUtils.cp('env.example', '.env')
    puts "✅ Created .env file"
    puts "\n⚠️  Please edit .env and add your API keys:"
    puts "   - FIRECRAWL_API_KEY (required)"
    puts "   - OPENROUTER_API_KEY (optional, for AI features)"
  else
    puts "❌ Template file 'env.example' not found"
  end
end

puts "\n🎉 Setup complete!"
puts "\n📝 Next steps:"
puts "   1. Edit .env file and add your API keys"
puts "   2. Run: ruby main.rb"
