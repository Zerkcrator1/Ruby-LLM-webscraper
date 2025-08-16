require 'httparty'
require 'json'

# AI Analyzer using OpenRouter API
class AIAnalyzer
  include HTTParty
  
  def initialize
    @api_key = ENV['OPENROUTER_API_KEY']
    @base_url = 'https://openrouter.ai/api/v1'
    
    if @api_key
      self.class.headers({
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json',
        'HTTP-Referer' => 'https://github.com/your-repo',
        'X-Title' => 'Ruby Web Scraper'
      })
    else
      puts "⚠️  AI Analyzer is disabled. Add your OPENROUTER_API_KEY to enable AI features."
    end
  end

  def analyze_content(content, analysis_type = 'summary')
    return "AI analysis is disabled. Please configure your OPENROUTER_API_KEY." unless @api_key
    
    prompt = case analysis_type
    when 'summary'
      "Please provide a concise summary of the following content:\n\n#{content}"
    when 'sentiment'
      "Analyze the sentiment of the following content and provide insights:\n\n#{content}"
    when 'key_points'
      "Extract the key points and main ideas from the following content:\n\n#{content}"
    when 'qa'
      "Answer questions about the following content:\n\n#{content}"
    else
      "Analyze the following content:\n\n#{content}"
    end

    call_openrouter_api(prompt)
  end

  def compare_content(content_list, comparison_type = 'similarities')
    return "AI analysis is disabled. Please configure your OPENROUTER_API_KEY." unless @api_key
    
    combined_content = content_list.map.with_index do |content, index|
      "Content #{index + 1}:\n#{content}\n"
    end.join("\n")

    prompt = case comparison_type
    when 'similarities'
      "Find similarities between the following pieces of content:\n\n#{combined_content}"
    when 'differences'
      "Find differences between the following pieces of content:\n\n#{combined_content}"
    when 'ranking'
      "Rank the following pieces of content by relevance and quality:\n\n#{combined_content}"
    else
      "Compare the following pieces of content:\n\n#{combined_content}"
    end

    call_openrouter_api(prompt)
  end

  def generate_insights(scraped_data)
    return "AI analysis is disabled. Please configure your OPENROUTER_API_KEY." unless @api_key
    
    content = scraped_data.is_a?(Array) ? scraped_data.join("\n\n") : scraped_data.to_s
    prompt = "Based on the following scraped web content, provide key insights and analysis:\n\n#{content}"
    
    call_openrouter_api(prompt)
  end

  private

  def call_openrouter_api(prompt)
    payload = {
      model: 'anthropic/claude-3.5-sonnet',
      messages: [
        {
          role: 'user',
          content: prompt
        }
      ],
      max_tokens: 2000,
      temperature: 0.7
    }

    begin
      response = self.class.post("#{@base_url}/chat/completions", body: payload.to_json)
      
      if response.success?
        result = JSON.parse(response.body)
        result.dig('choices', 0, 'message', 'content') || "No response content"
      else
        "API Error: #{response.code} - #{response.body}"
      end
    rescue => e
      "Error calling OpenRouter API: #{e.message}"
    end
  end
end
