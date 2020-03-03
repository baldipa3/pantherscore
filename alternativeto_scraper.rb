require 'mechanize'
require 'pry'
require 'down'
require 'webdrivers'
require 'watir'

def trigger_scrape
  agent = Mechanize.new
  agent.user_agent = 'Custom agent'
  homepage = agent.get('https://alternativeto.net')
  category_links = homepage.search('.sub-categories-menu li a').each do |category|
    category_link = "https:#{category['href']}all/"
    category_loop(category_link)
  end
end

def service_scrape(service, description_element)
  p name = service.at_css('h1').text.strip
  discontinued = service.at_css('.label-discontinued')
  p discontinued ? true : false
  p lead = service.at_css('.lead').children[0].text.strip
  company = service.at_css('.lead').children[1]
  p company.text.strip unless company.nil?
  company_url = service.at_css('.lead').children[1]
  p company_url['href'] unless company.nil?
  p service.at_css(description_element).text
  url = service.at_css('.icon-official-website')
  p url['href'] unless url.nil?
  categories = service.css('.label[href^="/category"]').each { |category| p category.text.strip }
  icon = service.at_css('img[src^="//d2.alternativeto.net/dist/icons"]')
  icon_link = "https:#{icon['src']}".gsub(/=\d+/, '=200')
  Down.download(icon_link, destination: "../../../Downloads/")
end

def service_loop(services_links)
  services = services_links.map do |link|
    service = link.click
    about_link = service.link_with(class: 'btn btn-complementary-view')
    if about_link.nil?
      service_scrape(service, '.item-desc')
    else

      service = about_link.click
      service_scrape(service, '.main-info p')
    end
    # binding.pry
    # p service.button_with(class: 'btn-load-apps').click
    alternatives = service.css('h3 a[href^="/software"]').each do |alternative|
      p alternative.text.strip
      p alternative_url = "https://alternativeto.net#{alternative['href']}"
    end
  end
end

def category_loop(category_link)
  agent = Mechanize.new
  agent.user_agent = 'Custom agent'
  page = agent.get(category_link)
  services_links = page.links_with(href: %r{^/software/.+})
  service_loop(services_links)
end

trigger_scrape
