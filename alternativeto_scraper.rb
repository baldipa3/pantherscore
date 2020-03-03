require 'rails'
require 'mechanize'
require 'pry'
require 'down'
require 'selenium-webdriver'

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
  2.times do
    category_page = category_link + "?p=#{page}"
    category_loop(category_page)
    page += 1
  end
end

def service_scrape(service, description_element)
  # name
  p name = service.at_css('h1').text.strip
  # discontinued?
  discontinued = service.at_css('.label-discontinued').nil?
  p discontinued ? true : false
  # lead
  p lead = service.at_css('.lead').children[0].text.strip
  # company
  company = service.at_css('.lead').children[1]
  p company.text.strip if company.present?
  # company_url
  company_url = service.at_css('.lead').children[1]
  p company_url['href'] if company.present?
  # description
  p description = service.at_css(description_element).text
  # url
  url = service.at_css('.icon-official-website')
  p url['href'] if url.present?
  # categories
  categories = service.css('.label[href^="/category"]').each { |category| p category.text.strip }
  # logo
  icon = service.at_css('img[src^="//d2.alternativeto.net/dist/icons"]')
  p icon_link = "https:#{icon['src']}".gsub(/=\d+/, '=200')
  Down.download(icon_link, destination: "../../../Downloads/")
end

def service_loop(services_links)
  services = services_links.map do |link|
    service = link.click
    about_link = service.link_with(class: 'btn btn-complementary-view')
    more_alternatives_link = service.link_with(text: " NEXT PAGE ")
    # alternatives
    alternatives = service.css('h3 a[href^="/software"]').each do |alternative|
      p alternative.text.strip
      p alternative_url = "https://alternativeto.net#{alternative['href']}"
    end
    # more alternatives
    if more_alternatives_link.present?
      alternatives = more_alternatives_link.click
      more_alternatives = alternatives.css('h3 a[href^="/software"]').each do |alternative|
        p alternative.text.strip
        p alternative_url = "https://alternativeto.net#{alternative['href']}"
      end
    end

    if about_link.present?
      service = about_link.click
      service_scrape(service, '.main-info p')
    else
      service_scrape(service, '.item-desc')
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
