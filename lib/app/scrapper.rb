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
# get_townhall_name RECUPERE LA LISTE DES NOMS DES VILLES

  def get_townhall_url(annuaire)
    town_list_url =[]
    annuaire.xpath('//p/a').each do |el|
    url = "https://www.annuaire-des-mairies.com#{el.attr('href')[1..-1]}"
      town_list_url << url
    end
    return town_list_url
  end
#get_townhall_url RECUPERE LA LISTE DES URLS DES MAIRIES DES VILLES (UTILES POUR RECUPERER LEURS MAILS)

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
#get_town_list_mail RECUPERE LA LISTE DES MAILS DES VILLES

  def get_city_email_final(annuaire)
    town_with_mail = get_townhall_name(annuaire).zip(get_town_list_mail(annuaire))
    final_array = []
    town_with_mail.each do |e|
        final_array << {e[0] => e[1]}
    end
    return final_array
  end
#get_city_email_final ASSOCIE LA LISTE DES VILLES ET LA LISTE DE LEURS EMAIL EN UN ARRAY DE HASHES

  def perform
    final =[]
    final = get_city_email_final(Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html')))
  end
#perform ACTIVE LA FONCTION DE RECUPERATION FINAL

  def save_as_JSON
    tempArr = get_city_email_final(Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html')))
    File.open("db/emails.json","w") do |f|
      f.write(tempArr.to_json)
    end
  end
# save_as_JSON RECUPÈRE LES DONNÉES FINALES DU get_city_email_final POUR LES CONVERTIR EN UN FICHIER JSON

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
#save_as_csv RECUPÈRE LES DONNÉES FINALES DU get_city_email_final POUR LES CONVERTIR EN UN FICHIER CSV

  def save_as_spreadsheet
    annuaire_valdoise = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("1Jg52TwK2uIWOSNE8DvnoheXqVBFKpDD5APNxXUVk-1c").worksheets[0]
    ws["A1"] = "MAIRIES"
    ws["B1"] = "EMAILS"
    i = 2
    j = 2
    get_townhall_name(annuaire_valdoise).each do |e|
      ws["A#{i}"] = e
      i +=1
    end
    get_town_list_mail(annuaire_valdoise).each do |e|
      ws["B#{j}"] = e
      j +=1
    end
    ws.save
  end
# save_as_spreadsheet RECUPERE LA LISTE DES NOMS DE VILLES (VIA get_townhall_name) ET
# LA LISTE DES EMAILS DES VILLES (VIA get_town_list_mail) POUR LES INTRODUIRE DANS UN EXCEL GOOGLE

end
