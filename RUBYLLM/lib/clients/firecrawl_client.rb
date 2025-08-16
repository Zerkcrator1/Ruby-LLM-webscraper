require 'httparty'
require 'json'

# Firecrawl API Client
class FirecrawlClient
  include HTTParty
  
  def initialize
    @api_key = ENV['FIRECRAWL_API_KEY']
    @base_url = 'https://api.firecrawl.dev'
    
    raise "FIRECRAWL_API_KEY not found in environment variables" unless @api_key
    
    self.class.headers({
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    })
  end

  # Scrape a single URL
  def scrape_url(url, options = {})
    payload = {
      url: url,
      pageOptions: {
        onlyMainContent: options[:only_main_content] || false,
        includeHtml: options[:include_html] || false,
        screenshot: options[:screenshot] || false
      }
    }

    response = self.class.post("#{@base_url}/scrape", body: payload.to_json)
    
    if response.success?
      JSON.parse(response.body)
    else
      raise "Firecrawl API error: #{response.code} - #{response.body}"
    end
  end

  # Scrape multiple URLs
  def scrape_urls(urls, options = {})
    payload = {
      urls: urls,
      pageOptions: {
        onlyMainContent: options[:only_main_content] || false,
        includeHtml: options[:include_html] || false,
        screenshot: options[:screenshot] || false
      }
    }

    response = self.class.post("#{@base_url}/scrape", body: payload.to_json)
    
    if response.success?
      JSON.parse(response.body)
    else
      raise "Firecrawl API error: #{response.code} - #{response.body}"
    end
  end

  # Search and scrape
  def search_and_scrape(query, options = {})
    payload = {
      query: query,
      pageOptions: {
        onlyMainContent: options[:only_main_content] || false,
        includeHtml: options[:include_html] || false,
        screenshot: options[:screenshot] || false
      },
      searchOptions: {
        limit: options[:limit] || 10
      }
    }

    response = self.class.post("#{@base_url}/search", body: payload.to_json)
    
    if response.success?
      JSON.parse(response.body)
    else
      raise "Firecrawl API error: #{response.code} - #{response.body}"
    end
  end
end
