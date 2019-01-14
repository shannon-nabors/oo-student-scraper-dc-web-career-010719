require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(File.read(index_url))
    students = []
    index.css("div.student-card").each do |student|
      student_hash = {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attribute("href").value
      }
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(File.read(profile_url))
    student_hash = {}
    profile.css("div.social-icon-container a").each do |icon|
      link = icon.attribute("href").value
      if link.include?("twitter")
        student_hash[:twitter] = link
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
      elsif link.include?("github")
        student_hash[:github] = link
      else
        student_hash[:blog] = link
      end
    end
    student_hash[:profile_quote] = profile.css("div.profile-quote").text
    student_hash[:bio] = profile.css("div.description-holder p").text
    student_hash
  end

end
