# RandomYouTube
# Authored by: Daniel P. Clark
# Date: 11-24-2012
# Requires Linux
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mightystring'
require 'randomyoutube/version'

module RandomYouTube
  ACC_CHARS = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ["\n"]).flatten.join
  REQUESTOR = "https://gdata.youtube.com/feeds/api/videos?q="
  THREE_WORDS = "shuf -n 3 /usr/share/dict/words"
  
  attr :mywords
  
  def self.local_exec
    @mywords = `#{THREE_WORDS}`
    @mywords = @mywords.strip_byac(ACC_CHARS).split("\n")
    urlsearch = REQUESTOR + @mywords.join('+')
    Nokogiri::XML(open(urlsearch))
  end
  
  def self.human
    page = local_exec
    puts "Your search results for: #{@mywords.join(', ')}"
    if page.at('openSearch|totalResults').text.to_i > 0
      puts "Title: #{page.css('entry title').first.text}"
      puts "Link: #{page.css('entry link').first['href']}"
    else
      puts "There are no results for your search."
    end
  end
  
  def self.pretty
    page = local_exec
    if page.at('openSearch|totalResults').text.to_i > 0
      return ["Your search results for: #{@mywords.join(', ')}", "Title: #{page.css('entry title').first.text}", "Link: #{page.css('entry link').first['href']}"]
    else
      return nil
    end
  end
  
  def self.raw
    page = local_exec
    if page.at('openSearch|totalResults').text.to_i > 0
      return [@mywords.join(', '), page.css('entry title').first.text, page.css('entry link').first['href']]
    else
      return nil
    end
  end
  
  def self.human_must
    output = pretty while output == nil
    puts output
  end
  
  def self.pretty_must
    output = pretty while output == nil
    return output
  end
  
  def self.raw_must
    output = raw while output == nil
    return output
  end  
end # module RandomYouTube
