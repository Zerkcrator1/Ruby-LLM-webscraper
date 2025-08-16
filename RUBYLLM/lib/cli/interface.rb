require 'json'
require_relative '../clients/firecrawl_client'
require_relative '../services/ai_analyzer'

# Command Line Interface
class CLI
  def initialize
    @firecrawl = FirecrawlClient.new
    @analyzer = AIAnalyzer.new
  end

  def start
    loop do
      display_menu
      choice = gets.chomp.downcase
      
      case choice
      when '1'
        scrape_single_url
      when '2'
        scrape_multiple_urls
      when '3'
        search_and_scrape
      when '4'
        analyze_content
      when '5'
        compare_content
      when '6'
        generate_insights
      when 'q', 'quit', 'exit'
        puts "👋 Goodbye!"
        break
      else
        puts "❌ Invalid choice. Please try again."
      end
      
      puts "\n" + "="*50 + "\n"
    end
  end

  private

  def display_menu
    puts "\n📋 Available Options:"
    puts "1. Scrape single URL"
    puts "2. Scrape multiple URLs"
    puts "3. Search and scrape"
    puts "4. Analyze content"
    puts "5. Compare content"
    puts "6. Generate insights"
    puts "q. Quit"
    print "\nEnter your choice: "
  end

  def scrape_single_url
    print "Enter URL to scrape: "
    url = gets.chomp
    
    print "Include HTML? (y/n): "
    include_html = gets.chomp.downcase == 'y'
    
    print "Take screenshot? (y/n): "
    screenshot = gets.chomp.downcase == 'y'
    
    puts "\n🔄 Scraping URL..."
    
    begin
      result = @firecrawl.scrape_url(url, {
        include_html: include_html,
        screenshot: screenshot
      })
      
      puts "✅ Successfully scraped!"
      puts "Title: #{result['title']}"
      puts "Content length: #{result['markdown']&.length || 0} characters"
      
      save_result(result, "single_url_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def scrape_multiple_urls
    puts "Enter URLs (one per line, press Enter twice when done):"
    urls = []
    
    loop do
      url = gets.chomp
      break if url.empty?
      urls << url
    end
    
    return if urls.empty?
    
    puts "\n🔄 Scraping #{urls.length} URLs..."
    
    begin
      result = @firecrawl.scrape_urls(urls)
      
      puts "✅ Successfully scraped #{result.length} URLs!"
      
      result.each_with_index do |page, index|
        puts "#{index + 1}. #{page['url']} - #{page['title']}"
      end
      
      save_result(result, "multiple_urls_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def search_and_scrape
    print "Enter search query: "
    query = gets.chomp
    
    print "Number of results (default 10): "
    limit = gets.chomp.to_i
    limit = 10 if limit <= 0
    
    puts "\n🔄 Searching and scraping..."
    
    begin
      result = @firecrawl.search_and_scrape(query, { limit: limit })
      
      puts "✅ Found #{result.length} results!"
      
      result.each_with_index do |page, index|
        puts "#{index + 1}. #{page['url']} - #{page['title']}"
      end
      
      save_result(result, "search_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def analyze_content
    puts "Enter content to analyze (press Enter twice when done):"
    content = get_multiline_input
    
    return if content.strip.empty?
    
    puts "\n📊 Analysis types:"
    puts "1. Summary"
    puts "2. Sentiment"
    puts "3. Key points"
    puts "4. Q&A"
    
    print "Choose analysis type (1-4): "
    choice = gets.chomp
    
    analysis_type = case choice
    when '1' then 'summary'
    when '2' then 'sentiment'
    when '3' then 'key_points'
    when '4' then 'qa'
    else 'summary'
    end
    
    puts "\n🤖 Analyzing content..."
    
    begin
      result = @analyzer.analyze_content(content, analysis_type)
      puts "\n📝 Analysis Result:"
      puts result
      
      save_result({ analysis_type: analysis_type, result: result }, "analysis_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def compare_content
    puts "Enter first content (press Enter twice when done):"
    content1 = get_multiline_input
    
    puts "Enter second content (press Enter twice when done):"
    content2 = get_multiline_input
    
    return if content1.strip.empty? || content2.strip.empty?
    
    puts "\n🔄 Comparison types:"
    puts "1. Similarities"
    puts "2. Differences"
    puts "3. Ranking"
    
    print "Choose comparison type (1-3): "
    choice = gets.chomp
    
    comparison_type = case choice
    when '1' then 'similarities'
    when '2' then 'differences'
    when '3' then 'ranking'
    else 'similarities'
    end
    
    puts "\n🤖 Comparing content..."
    
    begin
      result = @analyzer.compare_content([content1, content2], comparison_type)
      puts "\n📊 Comparison Result:"
      puts result
      
      save_result({ comparison_type: comparison_type, result: result }, "comparison_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def generate_insights
    puts "Enter scraped data or content (press Enter twice when done):"
    content = get_multiline_input
    
    return if content.strip.empty?
    
    puts "\n🤖 Generating insights..."
    
    begin
      result = @analyzer.generate_insights(content)
      puts "\n💡 Insights:"
      puts result
      
      save_result({ insights: result }, "insights_#{Time.now.to_i}")
      
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def get_multiline_input
    content = []
    
    loop do
      line = gets.chomp
      break if line.empty? && content.last&.empty?
      content << line
    end
    
    content.join("\n")
  end

  def save_result(result, filename)
    # Create data directory if it doesn't exist
    Dir.mkdir('data') unless Dir.exist?('data')
    
    File.write("data/#{filename}.json", JSON.pretty_generate(result))
    puts "💾 Result saved to data/#{filename}.json"
  end
end
