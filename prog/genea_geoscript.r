library(sp)
library(leaflet)
library(rgdal)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(leafpop)
library(sf)
library(htmltools)
library(shiny)



## PART 1 - IN THIS PART THE CODE READS THE FILES AND ATTRIBUTES COLORS AND ICONS TO ELEMENTS

## Read the shapefile
countries <- readOGR('countries/countries.shp')
## Create the palette of colors for the shapefiles
palette_countries <- colorNumeric(palette = "YlOrRd", domain = countries$number)

## Read the csv
#data <- read.csv("GENEALOGIE_DATABASE_UTF-8_23072022.csv", encoding='UTF-8')
data_PARFAIT <- read.csv("GENEALOGIE_DATABASE_PARFAIT_UTF-8_23072022.csv", encoding='UTF-8')
data_PROKOSCH <- read.csv("GENEALOGIE_DATABASE_PROKOSCH_UTF-8_23072022.csv", encoding='UTF-8')
## Create a html popup
##Déclarations des Variables pour le bon focntionnement des lignes concernant les données relatives aux url d'états civil
url_EC_n_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_EC_naissance,"\">",data_PARFAIT$url_EC_naissance,"</a>")
url_RP_b_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_RP_bapteme,"\">",data_PARFAIT$url_RP_bapteme,"</a>")
url_a_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_affranchissement,"\">",data_PARFAIT$url_affranchissement,"</a>")
url_EC_m_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_EC_mariage,"\">",data_PARFAIT$url_EC_mariage,"</a>")
url_EC_d_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_EC_deces,"\">",data_PARFAIT$url_EC_deces,"</a>")
url_TD_n_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_TD_naissance,"\">",data_PARFAIT$url_TD_naissance,"</a>")
url_TP_b_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_TP_bapteme,"\">",data_PARFAIT$url_TP_bapteme,"</a>")
url_TD_a_PARFAIT  <- paste("<a href=\"",data_PARFAIT$url_TD_affranchissement,"\">",data_PARFAIT$url_TD_affranchissement,"</a>")
url_TD_m_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_TD_mariage,"\">",data_PARFAIT$url_TD_mariage,"</a>")
url_TD_d_PARFAIT <- paste("<a href=\"",data_PARFAIT$url_TD_deces,"\">",data_PARFAIT$url_TD_deces,"</a>")


url_EC_n_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_EC_naissance,"\">",data_PROKOSCH$url_EC_naissance,"</a>")
url_RP_b_PROKOSCH<- paste("<a href=\"",data_PROKOSCH$url_RP_bapteme,"\">",data_PROKOSCH$url_RP_bapteme,"</a>")
url_a_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_affranchissement,"\">",data_PROKOSCH$url_affranchissement,"</a>")
url_EC_m_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_EC_mariage,"\">",data_PROKOSCH$url_EC_mariage,"</a>")
url_EC_d_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_EC_deces,"\">",data_PROKOSCH$url_EC_deces,"</a>")
url_TD_n_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_TD_naissance,"\">",data_PROKOSCH$url_TD_naissance,"</a>")
url_TP_b_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_TP_bapteme,"\">",data_PROKOSCH$url_TP_bapteme,"</a>")
url_TD_m_PROKOSCH<- paste("<a href=\"",data_PROKOSCH$url_TD_mariage,"\">",data_PROKOSCH$url_TD_mariage,"</a>")
url_TD_d_PROKOSCH <- paste("<a href=\"",data_PROKOSCH$url_TD_deces,"\">",data_PROKOSCH$url_TD_deces,"</a>")


etat_NR <- "non renseigné"
etat_NC <- "non concerné.e"



#Dans le tableau de données ajouter : lieu baptème et lieu affranchissement

##Déclaration des Variables et de la boite <div> pour la création du popup html 
content_PARFAIT <- paste(
                 sep = "<br/>",
                 paste0("<div class='leaflet-popup-scrolled' style='max-width:1000px;max-height:1000px'>"),
                 paste0("<h1>", data_PARFAIT$prenoms," ", data_PARFAIT$nom_famille, "</h1>"),
                 paste0("<span style='color:#FF6666';>","Branche : ","</span> ", data_PARFAIT$Descendant),
                 paste0("<span style='color:#FF6666';>","Etat de la recherche : ","</span> ", data_PARFAIT$Statut_recherche,"<br>"),
                 paste0("<span style='color:#FF6666';>","Employé.e en qualité de ","</span> ", ifelse(data_PARFAIT$emploi != 0,data_PARFAIT$emploi,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Né.e le", "</span> ","<b>",ifelse(data_PARFAIT$date_naissance != 0,data_PARFAIT$date_naissance,etat_NR ),"</b>"," à ","<b>", ifelse(data_PARFAIT$lieu_naissance != 0,data_PARFAIT$lieu_naissance,etat_NR ) ,"</b>", " (",ifelse(data_PARFAIT$dpt_naissance != 0,data_PARFAIT$dpt_naissance,etat_NR ),", ",  ifelse(data_PARFAIT$pays_naissance != 0,data_PARFAIT$pays_naissance,etat_NR ), ")."),
                 paste0("<span style='color:#FF6666';>","Baptisé.e le", "</span> ","<b>", ifelse(data_PARFAIT$date_bapteme != 0,data_PARFAIT$date_bapteme,etat_NR ),"</b>"," à ", "<b>", ifelse(data_PARFAIT$lieu_naissance != 0,data_PARFAIT$lieu_naissance,etat_NR ),"</b>", " (",ifelse(data_PARFAIT$dpt_naissance != 0,data_PARFAIT$dpt_naissance,etat_NR ),", ", ifelse(data_PARFAIT$pays_naissance != 0,data_PARFAIT$pays_naissance,etat_NR ), ")."),
                 paste0("<span style='color:#FF6666';>","Affranchi.e le", "</span> ","<b>", ifelse(data_PARFAIT$date_affranchissement != 0,data_PARFAIT$date_affranchissement,etat_NC ),"</b>"," à ", "<b>", ifelse(data_PARFAIT$lieu_affranchissement != 0,data_PARFAIT$lieu_affranchissement,etat_NC ),"</b>", " (",ifelse(data_PARFAIT$dpt_affranchissement != 0,data_PARFAIT$dpt_affranchissement,etat_NC ),", ", ifelse(data_PARFAIT$pays_affranchissement != 0,data_PARFAIT$pays_affranchissement,etat_NC ), ")."),
                 paste0("<span style='color:#FF6666';>", "Marié.e à ", "</span> ","<b>",ifelse(data_PARFAIT$nom_epoux == 0,etat_NR,data_PARFAIT$nom_epoux ),"</b>"," le ","<b>", ifelse(data_PARFAIT$date_mariage == 0,etat_NR,data_PARFAIT$date_mariage ),"</b>"," à ","<b>",ifelse( data_PARFAIT$lieu_mariage != 0, data_PARFAIT$lieu_mariage,etat_NR ),"</b>", " (",ifelse(data_PARFAIT$dpt_mariage != 0,data_PARFAIT$dpt_mariage,etat_NR ),", ",  ifelse(data_PARFAIT$pays_mariage != 0,data_PARFAIT$pays_mariage,etat_NR ), ")."),
                 paste0("<span style='color:#FF6666';>","Décédé.e le", "</span> ","<b>", ifelse(data_PARFAIT$date_deces != 0,data_PARFAIT$date_deces,etat_NR ),"</b>"," à ","<b>",ifelse( data_PARFAIT$lieu_deces != 0, data_PARFAIT$lieu_deces,etat_NR ),"</b>", " (",ifelse(data_PARFAIT$dpt_deces != 0,data_PARFAIT$dpt_deces,etat_NR ),", ",  ifelse(data_PARFAIT$pays_deces != 0,data_PARFAIT$pays_deces,etat_NR ), ")."),
                 paste0("<span style='color:#FF6666';>","Enfant de", "</span> ", ifelse(data_PARFAIT$enfant_de != 0,data_PARFAIT$enfant_de,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Parent de", "</span> ", ifelse(data_PARFAIT$parent_de != 0,data_PARFAIT$parent_de,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Fratrie de", "</span> ", ifelse(data_PARFAIT$fratrie_de != 0,data_PARFAIT$fratrie_de,etat_NR )),
                 paste0("<h3 style='color:#FF6666';> Acte d'état civil / Registres Paroissiaux </h3>"),
                 paste0("<span style='color:#FF6666';>","Acte de naissance : </span> "," n&deg; ", ifelse(data_PARFAIT$n_EC_naissance != 0,data_PARFAIT$n_EC_naissance,etat_NR ),", page ", ifelse(data_PARFAIT$page_EC_naissance != 0,data_PARFAIT$page_EC_naissance,etat_NR ),", url : ",ifelse(data_PARFAIT$url_EC_naissance != 0,url_EC_n_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Registre des baptême : </span> "," n&deg; ", ifelse(data_PARFAIT$n_RP_bapteme != 0,data_PARFAIT$n_RP_bapteme,etat_NR ),", page ", ifelse(data_PARFAIT$page_RP_bapteme != 0,data_PARFAIT$page_RP_bapteme,etat_NR ),", url : ",ifelse(data_PARFAIT$url_RP_bapteme != 0,url_RP_b_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Acte d'affranchissement : </span> "," n&deg; ", ifelse(data_PARFAIT$n_affranchissement != 0,data_PARFAIT$n_affranchissement,etat_NC ),", page ",  ifelse(data_PARFAIT$page_affranchissement != 0,data_PARFAIT$page_affranchissement,etat_NC ),", url : ",ifelse(data_PARFAIT$url_affranchissement != 0,url_a_PARFAIT,etat_NC )),
                 paste0("<span style='color:#FF6666';>","Acte de mariage : </span> "," n&deg; ", ifelse(data_PARFAIT$n_EC_mariage != 0,data_PARFAIT$n_EC_mariage,etat_NR ),", page ", ifelse(data_PARFAIT$page_EC_mariage != 0,data_PARFAIT$page_EC_mariage,etat_NR ),", url : ",ifelse(data_PARFAIT$url_EC_mariage != 0,url_EC_m_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","Acte de décès : </span> "," n&deg; ", ifelse(data_PARFAIT$n_EC_deces != 0,data_PARFAIT$n_EC_deces,etat_NR ),", page ", ifelse(data_PARFAIT$page_EC_deces != 0,data_PARFAIT$page_EC_deces,etat_NR ),", url : ",ifelse(data_PARFAIT$url_EC_deces != 0,url_EC_d_PARFAIT,etat_NR )),
                 paste0("<h3 style='color:#FF6666';> Tables Décennales / Tables Paroissiales </h3>"),
                 paste0("<span style='color:#FF6666';>","TD des naissance : </span> ","page ", ifelse(data_PARFAIT$page_TD_naissance != 0,data_PARFAIT$page_TD_naissance,etat_NR ),", url : ",ifelse(data_PARFAIT$url_TD_naissance != 0,url_TD_n_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","TP des baptême : </span> ","page ", ifelse(data_PARFAIT$page_TP_bapteme != 0,data_PARFAIT$page_TP_bapteme,etat_NR ),", url : ",ifelse(data_PARFAIT$url_TP_bapteme != 0,url_TP_b_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","TD des affranchissements : </span> "," page ",  ifelse(data_PARFAIT$page_TD_affranchissement != 0,data_PARFAIT$page_TD_affranchissement,etat_NC ),", url : ",ifelse(data_PARFAIT$url_TD_affranchissement != 0,url_TD_a_PARFAIT,etat_NC )),
                 paste0("<span style='color:#FF6666';>","TD des mariage : </span> "," page ", ifelse(data_PARFAIT$page_TD_mariage != 0,data_PARFAIT$page_TD_mariage,etat_NR ),", url : ",ifelse(data_PARFAIT$url_TD_mariage != 0,url_TD_m_PARFAIT,etat_NR )),
                 paste0("<span style='color:#FF6666';>","TD des décès : </span> "," page ", ifelse(data_PARFAIT$page_TD_deces != 0,data_PARFAIT$page_TD_deces,etat_NR ),", url : ",ifelse(data_PARFAIT$url_TD_deces != 0,url_TD_d_PARFAIT,etat_NR )),
                 paste0("</div>"))


content_PROKOSCH <- paste(
  sep = "<br/>",
  paste0("<div class='leaflet-popup-scrolled' style='max-width:1000px;max-height:1000px'>"),
  paste0("<h1>", data_PROKOSCH$prenoms," ", data_PROKOSCH$nom_famille, "</h1>"),
  paste0("<span style='color:#FF6666';>","Branche : ","</span> ", data_PROKOSCH$Descendant),
  paste0("<span style='color:#FF6666';>","Etat de la recherche : ","</span> ", data_PROKOSCH$Statut_recherche,"<br>"),
  paste0("<span style='color:#FF6666';>","Employé.e en qualité de ","</span> ", ifelse(data_PROKOSCH$emploi != 0,data_PROKOSCH$emploi,etat_NR )),  paste0("<span style='color:#FF6666';>","Né.e le", "</span> ","<b>",ifelse(data_PROKOSCH$date_naissance != 0,data_PROKOSCH$date_naissance,etat_NR ),"</b>"," à ","<b>", ifelse(data_PROKOSCH$lieu_naissance != 0,data_PROKOSCH$lieu_naissance,etat_NR ) ,"</b>", " (",ifelse(data_PROKOSCH$dpt_naissance != 0,data_PROKOSCH$dpt_naissance,etat_NR ),", ",  ifelse(data_PROKOSCH$pays_naissance != 0,data_PROKOSCH$pays_naissance,etat_NR ), ")."),
  paste0("<span style='color:#FF6666';>","Baptisé.e le", "</span> ","<b>", ifelse(data_PROKOSCH$date_bapteme != 0,data_PROKOSCH$date_bapteme,etat_NR ),"</b>"," à ", "<b>", ifelse(data_PROKOSCH$lieu_naissance != 0,data_PROKOSCH$lieu_naissance,etat_NR ),"</b>", " (",ifelse(data_PROKOSCH$dpt_naissance != 0,data_PROKOSCH$dpt_naissance,etat_NR ),", ", ifelse(data_PROKOSCH$pays_naissance != 0,data_PROKOSCH$pays_naissance,etat_NR ), ")."),
  paste0("<span style='color:#FF6666';>", "Marié.e à ", "</span> ","<b>",ifelse(data_PROKOSCH$nom_epoux == 0,etat_NR,data_PROKOSCH$nom_epoux ),"</b>"," le ","<b>", ifelse(data_PROKOSCH$date_mariage == 0,etat_NR,data_PROKOSCH$date_mariage ),"</b>"," à ","<b>",ifelse( data_PROKOSCH$lieu_mariage != 0, data_PROKOSCH$lieu_mariage,etat_NR ),"</b>", " (",ifelse(data_PROKOSCH$dpt_mariage != 0,data_PROKOSCH$dpt_mariage,etat_NR ),", ",  ifelse(data_PROKOSCH$pays_mariage != 0,data_PROKOSCH$pays_mariage,etat_NR ), ")."),
  paste0("<span style='color:#FF6666';>","Décédé.e le", "</span> ","<b>", ifelse(data_PROKOSCH$date_deces != 0,data_PROKOSCH$date_deces,etat_NR ),"</b>"," à ","<b>",ifelse( data_PROKOSCH$lieu_deces != 0, data_PROKOSCH$lieu_deces,etat_NR ),"</b>", " (",ifelse(data_PROKOSCH$dpt_deces != 0,data_PROKOSCH$dpt_deces,etat_NR ),", ",  ifelse(data_PROKOSCH$pays_deces != 0,data_PROKOSCH$pays_deces,etat_NR ), ")."),
  paste0("<span style='color:#FF6666';>","Enfant de", "</span> ", ifelse(data_PROKOSCH$enfant_de != 0,data_PROKOSCH$enfant_de,etat_NR )),
  paste0("<span style='color:#FF6666';>","Parent de", "</span> ", ifelse(data_PROKOSCH$parent_de != 0,data_PROKOSCH$parent_de,etat_NR )),
  paste0("<span style='color:#FF6666';>","Fratrie de", "</span> ", ifelse(data_PROKOSCH$fratrie_de != 0,data_PROKOSCH$fratrie_de,etat_NR )),
  paste0("<h3 style='color:#FF6666';> Acte d'état civil / Registres Paroissiaux </h3>"),
  paste0("<span style='color:#FF6666';>","Acte de naissance : </span> "," n&deg; ", ifelse(data_PROKOSCH$n_EC_naissance != 0,data_PROKOSCH$n_EC_naissance,etat_NR ),", page ", ifelse(data_PROKOSCH$page_EC_naissance != 0,data_PROKOSCH$page_EC_naissance,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_EC_naissance != 0,url_EC_n_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","Acte de baptême : </span> "," n&deg; ", ifelse(data_PROKOSCH$n_RP_bapteme != 0,data_PROKOSCH$n_RP_bapteme,etat_NR ),", page ", ifelse(data_PROKOSCH$page_RP_bapteme != 0,data_PROKOSCH$page_RP_bapteme,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_RP_bapteme != 0,url_RP_b_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","Acte de mariage : </span> "," n&deg; ", ifelse(data_PROKOSCH$n_EC_mariage != 0,data_PROKOSCH$n_EC_mariage,etat_NR ),", page ", ifelse(data_PROKOSCH$page_EC_mariage != 0,data_PROKOSCH$page_EC_mariage,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_EC_mariage != 0,url_EC_m_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","Acte de décès : </span> "," n&deg; ", ifelse(data_PROKOSCH$n_EC_deces != 0,data_PROKOSCH$n_EC_deces,etat_NR ),", page ", ifelse(data_PROKOSCH$page_EC_deces != 0,data_PROKOSCH$page_EC_deces,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_EC_deces != 0,url_EC_d_PROKOSCH,etat_NR )),
  paste0("<h3 style='color:#FF6666';> Tables Décennales / Tables Paroissiales </h3>"),
  paste0("<span style='color:#FF6666';>","TD des naissance : </span> ","page ", ifelse(data_PROKOSCH$page_TD_naissance != 0,data_PROKOSCH$page_TD_naissance,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_TD_naissance != 0,url_TD_n_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","TP des baptême : </span> ","page ", ifelse(data_PROKOSCH$page_TP_bapteme != 0,data_PROKOSCH$page_TP_bapteme,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_TP_bapteme != 0,url_TP_b_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","TD des mariage : </span> "," page ", ifelse(data_PROKOSCH$page_TD_mariage != 0,data_PROKOSCH$page_TD_mariage,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_TD_mariage != 0,url_TD_m_PROKOSCH,etat_NR )),
  paste0("<span style='color:#FF6666';>","TD des décès : </span> "," page ", ifelse(data_PROKOSCH$page_TD_deces != 0,data_PROKOSCH$page_TD_deces,etat_NR ),", url : ",ifelse(data_PROKOSCH$url_TD_deces != 0,url_TD_d_PROKOSCH,etat_NR )),
  paste0("</div>"))

## Create the palette of colors
palette_data <- colorNumeric("YlGn", data$decades)

## Create an image through the use of a link
url_prokosh <- "https://cdn-icons-png.flaticon.com/512/375/375303.png"
  #"https://www.pikpng.com/pngl/m/135-1358937_arbre-tubes-dessin-paysager-pinterest-architecture-foret-arbre.png"
url_parfait <- "https://cdn-icons-png.flaticon.com/512/374/374994.png"
prokosh_icon <-  makeIcon(url_prokosh, url_prokosh, 40, 40)
parfait_icon <-  makeIcon(url_parfait, url_parfait, 40, 40)

## PART 2 - IN THIS PART THE CODE ADDS ELEMENT ON THE MAP LIKE POLYGONS, POINTS AND IMAGES.

m <- leaflet() %>%
  ## Basemap
  ##addTiles(tile)        %>%
 
  
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  ## Add a zoom reset button
  addResetMapButton() %>%
  ## Add a Minimap to better navigate the map
  addMiniMap() %>%
  ## Add a coordinates reader
  leafem::addMouseCoordinates() %>%
  ## define the view
  setView(lng = 3.721387, 
          lat = 45.546099, 
          zoom = 3 ) %>%
  
  ## Add the polygons of the shapefiles
  #addPolygons(data = countries,
   #           stroke = FALSE, 
              #smoothFactor = 0.2, 
              #fillOpacity = 1,
              #color = ~palette_countries(number),
              #group = "Countries",
              #label = ~paste("In", titles, "there are", number, " personnes", sep = " ")) %>%
 
   ## Add a legend with the occurrences of the toponyms according to the macro areas
 # addLegend("bottomleft", 
  #          pal = palette_countries, 
   #         values = countries$number,
    #        title = "Personnes par pays:",
     #       labFormat = labelFormat(suffix = " personnes"),
      #      opacity = 1,
       #     group = "Countries") %>%
  
  ## Add Markers with clustering options
#addAwesomeMarkers(data = data, 
#                   lng = ~lng,
#                   lat = ~lat, 
#                  popup = c(content), 
#                  group = "Personnes",
#                  options = popupOptions(Width = 500, Height = 500),
#                  clusterOptions = markerClusterOptions()
#                  )%>%
  
  ## Add Circles with quatitative options
# addCircleMarkers(data = data, 
#                   lng = data$lng,
#                  lat = data$lat,
#                   fillColor = ~palette_data(),
#                 color = "black",
#                  weight = 1,
#                  radius = ,
#                 stroke = TRUE,
#                 fillOpacity = 0.5,
#                 group = "Personne",
#                 label = ~paste(data$nom_famille, 
#                             "est né(e) en ",
#                              data$date_naissance,".")) %>%
  
  ## Add a legend with the occurrences of the toponyms according to the macro areas
 # addLegend("bottomleft", 
  #          pal = palette_data, 
   #         values = data$decades,
    #        title = "Naissance par année:",
     #       labFormat = labelFormat(suffix = " année"),
      #      opacity = 1,
       #     group = "par an") %>%
  
  ## Add Markers with special icons

addMarkers(data = data_PARFAIT,
             lng = ~lng, 
             lat = ~lat, 
             icon = parfait_icon,
             group = "Branche PARFAIT",
             #popup = ~paste0(nom_famille)) 
           popup = c(content_PARFAIT),
  clusterOptions = markerClusterOptions())%>%
  
addMarkers(data = data_PROKOSCH,
             lng = ~lng, 
             lat = ~lat, 
             icon = prokosh_icon,
             group = "Branche Prokosch",
            # popup = ~paste0(nom_famille)
            popup = c(content_PROKOSCH),
           clusterOptions = markerClusterOptions()) %>%


  
  ## Add a legend with the credits
  addLegend("topright", 
            
            colors = c("trasparent"),
            labels=c("par Caroline Koudoro-Parfait"),
            
            title="Arbre généalogique des Familles Parfait et Prokosch: ") %>%
  
  
  ## PART 3 - IN THIS PART THE CODE MANAGE THE LAYERS' SELECTOR
  
  ## Add the layer selector which allows you to navigate the possibilities offered by this map
  
  addLayersControl(baseGroups = c("Branche PARFAIT",
                                  "Branche Prokosch",
                                  "Empty layer"),
                   
                   overlayGroups = c(#"Countries",
                                     "Branche PARFAIT",
                                     "Branche Prokosch"),
                   
                   options = layersControlOptions(collapsed = TRUE)) %>%
  
  ## Hide the layers that the users can choose as they like
  hideGroup(c("Empty"#,
             # "Branche PARFAIT",
              #"Branche Prokosch"
             ))

## Show the map  
m

