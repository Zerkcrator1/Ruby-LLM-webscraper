require_relative 'clients/firecrawl_client'
require_relative 'cli/interface'

# Main application class
class RubyWebScraperApp
  def initialize
    @firecrawl = FirecrawlClient.new
    @cli = CLI.new
  end

  def run
    puts "🚀 Ruby Web Scraper with Firecrawl"
    puts "=================================="
    puts "Firecrawl API Key: #{ENV['FIRECRAWL_API_KEY'] ? '✅ Configured' : '❌ Missing'}"
    puts "OpenRouter API Key: #{ENV['OPENROUTER_API_KEY'] ? '✅ Configured' : '❌ Missing (AI features disabled)'}"
    puts ""
    
    @cli.start
  end
end
