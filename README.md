# Ruby Web Scraper with Firecrawl

A Ruby-based web scraping tool powered by Firecrawl API with optional AI analysis capabilities using OpenRouter.

## Features

- 🕷️ **Web Scraping**: Scrape single URLs, multiple URLs, or search and scrape
- 🤖 **AI Analysis**: Analyze scraped content with various analysis types
- 📊 **Content Comparison**: Compare multiple pieces of content
- 💡 **Insights Generation**: Generate insights from scraped data
- 💾 **Data Persistence**: Save results as JSON files
- 🎯 **Easy CLI**: Interactive command-line interface

## Project Structure

```
RUBYLLM/
├── lib/
│   ├── clients/
│   │   └── firecrawl_client.rb    # Firecrawl API client
│   ├── services/
│   │   └── ai_analyzer.rb         # AI analysis service
│   ├── cli/
│   │   └── interface.rb           # Command-line interface
│   └── ruby_web_scraper_app.rb    # Main application class
├── config/                        # Configuration files
├── data/                          # Output data directory
├── Gemfile                        # Dependencies
├── main.rb                        # Entry point
├── env.example                    # Environment variables template
└── README.md                      # This file
```

## Setup

1. **Install Dependencies**
   ```bash
   bundle install
   ```

2. **Configure Environment Variables**
   ```bash
   cp env.example .env
   ```
   
   Edit `.env` and add your API keys:
   - **FIRECRAWL_API_KEY**: Required - Get from [Firecrawl](https://www.firecrawl.dev/)
   - **OPENROUTER_API_KEY**: Optional - Get from [OpenRouter](https://openrouter.ai/) for AI features

## Usage

Run the application:
```bash
ruby main.rb
```

### Available Options

1. **Scrape Single URL**: Extract content from a single webpage
2. **Scrape Multiple URLs**: Batch scrape multiple URLs
3. **Search and Scrape**: Search for content and scrape results
4. **Analyze Content**: AI-powered content analysis
5. **Compare Content**: Compare multiple pieces of content
6. **Generate Insights**: Generate insights from scraped data

### Analysis Types

- **Summary**: Generate concise summaries
- **Sentiment**: Analyze sentiment and emotions
- **Key Points**: Extract main ideas and key points
- **Q&A**: Answer questions about content

### Comparison Types

- **Similarities**: Find common themes and similarities
- **Differences**: Identify key differences
- **Ranking**: Rank content by relevance and quality

## API Requirements

### Firecrawl API
- **Required**: Yes
- **Purpose**: Web scraping functionality
- **Website**: https://www.firecrawl.dev/
- **Features**: Single URL scraping, batch scraping, search and scrape

### OpenRouter API
- **Required**: No (optional for AI features)
- **Purpose**: AI-powered content analysis
- **Website**: https://openrouter.ai/
- **Features**: Content analysis, comparison, insights generation

## Output

All results are automatically saved as JSON files in the `data/` directory with descriptive filenames and timestamps.

## Error Handling

The application includes comprehensive error handling for:
- Missing API keys
- Network issues
- Invalid URLs
- API rate limits
- Invalid user input

## Development

### Dependencies
- Ruby 3.0+
- HTTParty for API requests
- Dotenv for environment variable management
- JSON for data serialization

### Development Tools (optional)
- RuboCop for code style
- Pry for debugging
- RSpec for testing
- WebMock for API testing

## License

This project is open source and available under the MIT License.
