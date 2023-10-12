#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 19 19:06:15 2023

@author: obtic2023
"""



import re
import glob
import json
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt



def read_json (chemin):
    with open(chemin) as json_data: 
        dist =json.load(json_data)
        
        return dist


def stocker( chemin, contenu):

    w =open(chemin, "w")
    w.write(json.dumps(contenu , indent = 2))
    w.close()
    print(chemin)
    



## MAIN
path_corpus="../DATA/ELTeCFRA_distance/*/*.json"
tableau={}
liste_auteur=[]
liste_version_spacy=[]
liste_config=[]
liste_dist=[]
liste_auteur=[]
liste_name_metric=[]
liste_version=[]




for path_autor in glob.glob(path_corpus):
    # print(path_autor)
    nom_fich=path_autor.split("/")[2]
    nom_fich=nom_fich.split("_")
    nom_fich="_".join([nom_fich[0],nom_fich[1]])

    
    
    # for dist_file in glob.glob(f"{path_autor}/*.json"):
    # print(dist_file)
    distance=read_json(path_autor)
    autor=path_autor.split("/")[4]
    autor=autor.split("_")[0]
    version=path_autor.split("/")[-1]
    version=version.split("_")[1]

    
    liste_distance=[]
    for key, config in distance.items():
        # print(key)
        
        for paire, resultats in config.items():
                    
            
            
            for name_metric, liste in resultats.items():
                # print(liste)
                
                for r in liste:
                    liste_name_metric.append(name_metric)
                    liste_config.append(version)#pour les configurations OCR+NER
                        
                    liste_auteur.append(autor)                       
                    liste_dist.append(r)
            
                
    

tableau["Auteur"]=liste_auteur
tableau["Configuration"]=liste_config
tableau["Distance"]=liste_dist
tableau["Metric"]=liste_name_metric
data_tab = pd.DataFrame(tableau)
data_tab = data_tab.sort_values('Configuration')


sns.catplot(data_tab=tips, x="Configuration", y="Distance")
# print(data_tab)
# sns.set_theme(style="ticks")

# # Initialize the figure with a logarithmic x axis

# f, ax = plt.subplots(figsize=(7, 6))
# ax.set_xscale("linear")


# # Load the example planets dataset
# # planets = sns.load_dataset("planets")

# # Plot the orbital period with horizontal boxes
# # sns.boxplot(x=data_tab.Distance[(data_tab.Metric=="cosinus") & (data_tab.Configuration=="kraken--lg--lg")],  y=data_tab.Configuration[data_tab.Configuration=="kraken--lg--lg"], data=data_tab,
# #             whis=[0, 100], width=.6, palette="vlag")
# sns.boxplot(x="Distance",  y="Configuration", data=data_tab,
#             whis=[0, 1], width=.6, palette="vlag")

# # Add in points to show each observation
# # sns.stripplot(x=data_tab.Distance[(data_tab.Metric=="cosinus") & (data_tab.Configuration=="kraken--lg--lg")], y=data_tab.Configuration[data_tab.Configuration=="kraken--lg--lg"], data=data_tab,
# #               size=4, color=".3", linewidth=0)
# sns.stripplot(x="Distance", y="Configuration", data=data_tab,
#               size=7, color=".3", linewidth=0)

# # Tweak the visual presentation
# ax.xaxis.grid(True)
# ax.set(ylabel="")

# # ax.yaxis.set_tick_params(direction = 'out', length = 20, width = 5,
# #                            color = 'red', labelsize = 20, pad = 20,
# #                            labelcolor = 'violet', right = True, left = True)
# plt.axis([0, 1, -1, 6])
# ax.yaxis.set_tick_params(labelsize = 20)
# ax.xaxis.set_tick_params(labelsize = 20)
# ax.xaxis.label.set_size(20)
# sns.despine(trim=True, left=True)

# # plt.savefig("../DATA/DISTANCES_GRAPH/%s_%s.png"%(nom_fich,tableau["Metric"][0]),dpi=300, bbox_inches="tight")
# plt.savefig("../DATA/DISTANCES_GRAPH/%s_REF_%s.png"%(nom_fich,tableau["Metric"][0]),dpi=300, bbox_inches="tight")
 
      
        
            
        
        
        
   
            
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    





















