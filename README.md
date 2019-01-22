Pour lancer l'application entrez dans votre terminal à l'adresse du directory correspondant :
$ ruby app.rb

app.rb requiert app/scrapper.rb
les gems necessaires à app.rb sont incluses dans app/scrapper.rb

scrapper.rb détient la classe HalltownsWithMails

Cette classe permet d'obtenir via ses fonctions internes :
 - La liste des villes du Val d'oise (via get_townhall_name(annuaire)) en array
 - La liste des mails des mairies du Val d'oise  (via get_town_list_mail(annuaire)) en array
 - La liste des URLs des mairies du Val d'oise (via get_townhall_url(annuaire)) en array
 - Le catalogue nom_des_villes/mails_des_mairies (via get_city_email_final(annuaire)) en array de   hashes

 - Convertir le catalogue en fichier JSON (via save_as_JSON)
 - Convertir le catalogue en fichier CSV (via save_as_csv)
 - Convertir le catalogue en page Google spreadsheet (via save_as_spreadsheet)

page Google spreadsheets
-->  https://docs.google.com/spreadsheets/d/1Jg52TwK2uIWOSNE8DvnoheXqVBFKpDD5APNxXUVk-1c/edit#gid=0
Demandez l'autorisation pour accéder au fichier en ligne

Les bases de données correspondant au catalogue en JSON et CSV sont contenues dans le dossier /db
