# require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require "google_drive"

class HalltownsWithMails

  attr_accessor :name_email

  def initialize
   @name_email = perform
  end

   annuaire_valdoise = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))

  def get_townhall_name(annuaire)
      town_list =[]
      annuaire.xpath('//p/a').each do |el|
      town_list << el.text
      end
      return town_list
  end

  def get_townhall_url(annuaire)
    town_list_url =[]
    annuaire.xpath('//p/a').each do |el|
    url = "https://www.annuaire-des-mairies.com#{el.attr('href')[1..-1]}"
    town_list_url << url
    end
    return town_list_url
  end

  def get_town_list_mail(annuaire)
    puts "Veuillez patienter pendant le scrapping ..."
    town_list_mail =[]
    get_townhall_url(annuaire).each do |e|
      adr = Nokogiri::HTML(open(e))
      mail = adr.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
      town_list_mail << mail
    end
    return town_list_mail
  end

  def get_city_email_final(annuaire)
  town_with_mail = get_townhall_name(annuaire).zip(get_town_list_mail(annuaire))
  final_array = []
    town_with_mail.each do |e|
        final_array << {e[0] => e[1]}
    end
    return final_array
  end

  def perform
    final =[]
    final = get_city_email_final(Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html')))
  end

  def save_as_JSON
    tempArr = get_city_email_final(Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html')))
    File.open("db/emails.json","w") do |f|
      f.write(tempArr.to_json)
    end
  end

  def save_as_csv

    annuaire = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
    town_with_mail = get_townhall_name(annuaire).zip(get_town_list_mail(annuaire))
    town_with_mail2 = []
    i =1
    town_with_mail.each do |c|
      c.unshift(i)
      town_with_mail2 << c
      i+=1
    end
    town_with_mail2 = town_with_mail2.map { |c| c.join(",") }.join(",\n")
    File.open("db/emails.csv","w") do |f|
      f.write(town_with_mail2)
    end
  end

  def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("pz7XtlQC-PYx-jrVMJErTcg").worksheets[0]
    p ws[2, 1]
    ws[2, 1] = "foo"
    ws[2, 2] = "bar"
    ws.save
    (1..ws.num_rows).each do |row|
      (1..ws.num_cols).each do |col|
        p ws[row, col]
      end
    end

  end

end

# a = HalltownsWithMails.new
# puts a.name_email

# def save_as_csv
#   annuaire = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
#   town_with_mail = get_townhall_name(annuaire).zip(get_town_list_mail(annuaire))
#   town_with_mail = town_with_mail.join(",")
#   tempArr = []
#   town_with_mail.each do |e|
#     tempArr << e.to_csv
#   end
#   #tempArr = tempArr.flatten
#   puts tempArr.inspect
#   File.open("db/emails.csv","w") do |f|
#     f.write(tempArr)
#   end
# end
