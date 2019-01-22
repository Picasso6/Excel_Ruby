require 'bundler'
Bundler.require


$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'

# require 'app/fichier_1'
# require 'views/fichier_2'

a = HalltownsWithMails.new
 a.save_as_csv
