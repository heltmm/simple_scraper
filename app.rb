require("bundler/setup")
require 'open-uri'
require 'pry'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

# html_data = open('http://web.archive.org/web/20090220003702/http://www.sitepoint.com/').read
# html_data = open('https://www.reddit.com/').read
#
# nokogiri_object = Nokogiri::HTML(html_data)
# using xPath
# tagcloud_elements = nokogiri_object.xpath("//ul[@class='tagcloud']/li/a")
# reddit_top_posts = nokogiri_object.xpath("//p[@class='title']/a")
# using css selectors
# tagcloud_elements = nokogiri_object.css("ul.tagcloud > li > a")
# reddit_top_posts.each do |post|
#   puts post.text
  # to get the attribute value of href
  # puts tagcloud_element['href']
# end
get('/') do
  erb(:index)
end

get('/reddit') do
  @posts = Post.all
  erb(:reddit)
end

post('/reddit') do
  reddit_nokogiri_object = Nokogiri::HTML(open('https://www.reddit.com/').read)
  top_posts = reddit_nokogiri_object.xpath("//p[@class='title']/a")
  top_posts.each do |post|
    Post.create({:title => post.text, :link => post['href']})
  end
  @posts = Post.all
  erb(:reddit)
end

get('/aww') do
  @awws = Aww.all
  erb(:aww)
end

post('/aww') do
  reddit_nokogiri_object = Nokogiri::HTML(open('https://www.reddit.com/r/aww').read)
  top_awws = reddit_nokogiri_object.xpath("//p[@class='title']/a")
  top_awws.each do |aww|
    Aww.create({:title => aww.text, :link => aww['href']})
  end
  @awws = Aww.all
  erb(:aww)
end
