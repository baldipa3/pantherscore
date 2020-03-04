require 'rails'
require 'mechanize'
require 'pry'
require 'json'
# require 'down'
# require 'selenium-webdriver'

def trigger_scrape
  agent = Mechanize.new
  agent.user_agent = 'Custom agent'
  homepage = agent.get('https://alternativeto.net')
  category_links = homepage.search('.sub-categories-menu li a').each do |category|
    category_link = "https:#{category['href']}all/"
    category_pagination(category_link)
  end
end

def category_pagination(category_link)
  page = 1
  25.times do
    category_page = category_link + "?p=#{page}"
    category_loop(category_page)
    page += 1
  end
end

def service_scrape(service, resolved_link, slug, more_alternatives_link, description_element)
  # name
  name = service.at_css('h1').text.strip
  alternativeto_url = resolved_link
  # discontinued?
  discontinued = service.at_css('.label-discontinued')
  discontinued = discontinued.present?
  # lead
  lead = service.at_css('.lead').children[0].text.strip
  # company
  company = service.at_css('.creator > a')
  company_name = company.text.strip.gsub('Created by ', '') if company.present?
  company_url = company['href'] if company.present?
  # description
  description = service.at_css(description_element).text
  # url
  url = service.at_css('.icon-official-website')
  url = url['href'] if url.present?
  # categories
  categories_array = []
  categories = service.css('.label[href^="/category"]').each { |category| categories_array << category.text.strip }
  # logo
  icon = service.at_css('img[src^="//d2.alternativeto.net/dist/icons"]')
  icon_url = "https:#{icon['src']}".gsub(/=\d+/, '=200')
  agent = Mechanize.new
  agent.user_agent = 'Custom agent'
  # agent.get(icon_url).body_io.string
  # Base64.encode64(agent.get(icon_url).body_io.string)
  encoded_icon = Base64.encode64(agent.get(icon_url).body_io.read)
  File.open("../../../Downloads/#{slug}.png", "wb") {|f| f.write(Base64.decode64(encoded_icon))}
  # alternatives
  alternatives_array = []
  alternatives = service.css('h3 a[href^="/software"]').each do |alternative|
    alternatives_array << {name: "#{alternative.text.strip}", slug: "#{alternative['href'].match(/software\/(.*?)\//)[1]}"}
  end
  # more alternatives
  if more_alternatives_link.present?
    alternatives = more_alternatives_link.click
    more_alternatives = alternatives.css('h3 a[href^="/software"]').each do |alternative|
      alternatives_array << {name: "#{alternative.text.strip}", slug: "#{alternative['href'].match(/software\/(.*?)\//)[1]}"}
    end
  end
  puts JSON.pretty_generate({
    name: name,
    alternativeto_url: alternativeto_url,
    slug: slug,
    discontinued: discontinued,
    lead: lead,
    company_name: company_name,
    company_url: company_url,
    description: description,
    url: url,
    categories: categories_array,
    alternatives: alternatives_array,
    icon_url: icon_url,
    encoded_icon: encoded_icon
  })
end

def service_loop(services_links)
  services = services_links.map do |link|
    # service_link
    resolved_link = link.resolved_uri.to_s
    slug = resolved_link.match(/software\/(.*?)\//)[1]

    begin
      service = link.click
    rescue Mechanize::ResponseCodeError => e
      next if e.response_code == '404'
    end

    about_link = service.link_with(class: 'btn btn-complementary-view')
    more_alternatives_link = service.link_with(text: " NEXT PAGE ")

    if about_link.present?
      service = about_link.click
      service_scrape(service, resolved_link, slug, more_alternatives_link, '.main-info p')
    else
      service_scrape(service, resolved_link, slug, more_alternatives_link, '.item-desc')
    end
  end
end

def category_loop(category_page)
  agent = Mechanize.new
  agent.user_agent = 'Custom agent'
  page = agent.get(category_page)
  services_links = page.links_with(href: %r{^/software/.+})
  services_links
  service_loop(services_links)
end

trigger_scrape
