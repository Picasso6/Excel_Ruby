require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'

a = HalltownsWithMails.new
#a.save_as_csv
#a.save_as_JSON
a.save_as_spreadsheet
