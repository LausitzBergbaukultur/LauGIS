#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 13 09:51:18 2022

@author: op
"""

from PyQt5.QtCore.QObject import QgisInterface

iface = QgisInterface() # in QGIS auf App-Ebene instanziiert

layer = iface.activeLayer()

####

request = QgsFeatureRequest().setFilterFid(6)
selected_feats = layer.getFeatures(request)
attr = [ feat.attributes() for feat in selected_feats ]
print(attr)

# QgsVectorLayer def:
# https://qgis.org/pyqgis/3.0/core/Vector/QgsVectorLayer.html
# -> getFeature(self, fid: int) → QgsFeature
## -> getFeatures(self, request: QgsFeatureRequest = QgsFeatureRequest()) → QgsFeatureIterator
## -> getSelectedFeatures(self, request: QgsFeatureRequest = QgsFeatureRequest()) → QgsFeatureIterator
### -> https://qgis.org/pyqgis/3.0/core/Feature/QgsFeatureRequest.html
## QgsFeatureIterator def:
## https://qgis.org/pyqgis/3.0/core/Feature/QgsFeatureIterator.html
# QgsFeature def:
# https://qgis.org/pyqgis/3.0/core/Feature/QgsFeature.html
# -> attribute(self, name: str) → object

return_erfasser = layer.getFeature(6).attribute('return_erfasser')

#def parse_rel_erfasser(relations):
    
    return_erfasser[0].strip('( )').rsplit(',')
    
    #rel_erfasser = [int(i) for i in return_erfasser[0].strip('( )').rsplit(',')]
rel_erfasser = list()
for n in return_erfasser:
    rel = list()
    for i in n.strip('( )').rsplit(','):
        if len(i) == 0:
            rel.append(0)
        else:
            rel.append(int(i))
    rel_erfasser.append(rel)
    
    
    
    
# https://qgis.org/pyqgis/3.0/gui/Attribute/QgsAttributeForm.html