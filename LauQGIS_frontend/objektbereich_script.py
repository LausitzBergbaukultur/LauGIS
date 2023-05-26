#!/usr/bin/env python3  
# -*- coding: utf-8 -*- 
# --------------------------------------------------------------------------------------------------
# @Author:      Alexandra Krug
# @Institution: Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
# @Date:        24.02.2023
# @Links:       https://github.com/LausitzBergbaukultur/LauGIS
# --------------------------------------------------------------------------------------------------

import math
import json
import operator
import requests
import webbrowser
from PyQt5.QtCore import Qt, QUrl
from PyQt5.QtWebKitWidgets import QWebView
from PyQt5.QtWidgets import QDialog, QWidget, QToolButton, QFormLayout, QGridLayout, QTableWidget, QDialogButtonBox, QTableWidgetItem, QAbstractScrollArea, QErrorMessage, QLabel, QHBoxLayout, QVBoxLayout, QComboBox, QHeaderView, QLineEdit, QCheckBox, QTabWidget, QMessageBox

error_dialog = QErrorMessage()
definitionen = list()
sachbegriffe = list()
local_feature = None
local_layer = None
local_dialog = None
url_manual = 'http://192.168.29.159/lauqgis/Handbuch_LauGIS.pdf'
url_laudata = 'http://192.168.29.159/laudata/'
url_laudata_tn = 'http://192.168.29.159/laudata_tn/'

def formOpen(dialog,layer,feature):
    # Scope: Zugriff auf relevante Ressourcen ermöglichen
    global local_feature
    global local_layer
    global local_dialog
    global definitionen
    global sachbegriffe
    global error_dialog
    local_feature = feature
    local_layer = layer
    local_dialog = dialog
 
    ## check if initialised with actual feature and correct .ui
    if len(feature.attributes()) > 0 and dialog.findChild(QDialog, 'objektbereich') is not None:
        # create definitions table
        project = QgsProject.instance() 
        # check if list is already populated
        if len(definitionen) == 0:
            try:
                def_layer = project.mapLayersByName('definitionen')[0]
            except:
                error_dialog.showMessage('Der Definitionslayer *definitionen* konnte nicht gefunden werden.')
            for feat in def_layer.getFeatures():
                definitionen.append(
                    {'tabelle':         feat['tabelle'], 
                     'id':              feat['id'], 
                     'bezeichnung':     feat['bezeichnung'],
                     'is_ausfuehrend':  feat['is_ausfuehrend']})
        # check if list is already populated
        if len(sachbegriffe) == 0:
            # create sachbegriffe table    
            try:
                [def_layer] = project.mapLayersByName('sachbegriffe')
            except:
                error_dialog.showMessage('Der Definitionslayer *sachbegriffe* konnte nicht gefunden werden.')
            for feat in def_layer.getFeatures():
                sachbegriffe.append(
                    {'id':                  feat['id'], 
                     'sachbegriff':         feat['sachbegriff'], 
                     'sachbegriff_ueber':   feat['sachbegriff_ueber'],
                     'kategorie':           feat['kategorie'],
                     'anlage':              feat['anlage'],
                     'anlage_erweitert':    feat['anlage_erweitert'],
                     'ref_sachbegriff_id':  feat['ref_sachbegriff_id'],
                     'sortierung':          feat['sortierung']
                     })
        
        # load all custom controls
        reload_controls()
            
# Feld: Datierung #####################################################        
        btn_datierung = local_dialog.findChild(QToolButton, 'btn_datierung')
        try:
            btn_datierung.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_datierung.clicked.connect(lambda: dlg_edit_datierung(QDialog()))

# Feld: Funktion / Nutzung ############################################        
        btn_nutzung = local_dialog.findChild(QToolButton, 'btn_nutzung')
        try:
            btn_nutzung.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_nutzung.clicked.connect(lambda: dlg_edit_nutzung(QDialog()))
        
# Feld: Personen #####################################################        
        btn_personen = local_dialog.findChild(QToolButton, 'btn_personen')
        try:
            btn_personen.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_personen.clicked.connect(lambda: dlg_edit_personen(QDialog()))
        
# Feld: Erfasser ######################################################
        btn_erfasser = dialog.findChild(QToolButton, 'btn_erfasser')
        try:
            btn_erfasser.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_erfasser.clicked.connect(lambda: dlg_edit_erfasser(QDialog()))
        
# Feld: Blickbeziehung ################################################        
        btn_blickbeziehung = local_dialog.findChild(QToolButton, 'btn_blickbeziehung')
        try:
            btn_blickbeziehung.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_blickbeziehung.clicked.connect(lambda: dlg_edit_blickbeziehung(QDialog()))

# Feld: Sachbegriff ##################################################        
        dlg_sachbegriff = QDialog()
        btn_sachbegriff = local_dialog.findChild(QToolButton, 'btn_sachbegriff')
        try:
            btn_sachbegriff.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_sachbegriff.clicked.connect(lambda: dlg_edit_sachbegriff(dlg_sachbegriff))

# Feld: Bilder ##################################################        
        btn_bilder = local_dialog.findChild(QToolButton, 'btn_bilder')
        try:
            btn_bilder.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_bilder.clicked.connect(lambda: dlg_edit_bilder(QDialog()))

# Feld: Literatur ###############################################        
        btn_literatur = local_dialog.findChild(QToolButton, 'btn_literatur')
        try:
            btn_literatur.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_literatur.clicked.connect(lambda: dlg_edit_literatur(QDialog()))
        
# Feld: Untergeordnete Objekte ################################################
        read_untergeordnet = (local_feature.attribute('read_untergeordnet') 
            if isinstance(local_feature.attribute('read_untergeordnet'), str)
            else '')
        # control ermitteln und text einfügen
        lbl_read_untergeordnet = local_dialog.findChild(QLabel, 'lbl_read_untergeordnet')
        lbl_read_untergeordnet.setText(read_untergeordnet)
        
# Menueleiste #################################################################
        btn_changetype = dialog.findChild(QToolButton, 'btn_changetype')
        try:
            btn_changetype.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_changetype.clicked.connect(lambda: changetype_object(QDialog()))
        
        btn_manual = dialog.findChild(QToolButton, 'btn_manual')
        try:
            btn_manual.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_manual.clicked.connect(lambda: webbrowser.open(url_manual, new=0, autoraise=True)) 

        dlg_preview = QDialog()
        btn_imagepreview = dialog.findChild(QToolButton, 'btn_imagepreview')
        btn_imagepreview.setEnabled(True if len(get_rel_bilder()) > 0 else False)
        try:
            btn_imagepreview.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_imagepreview.clicked.connect(lambda: dlg_vorschau(dlg_preview))

####################################################################################################

# refresh list on primary dialog
def reload_controls():

# Feld: Datierung #####################################################
    datierung = [date['ref_ereignis'] + ': ' + date['datierung'] 
                if date['ref_ereignis'] != 'FREITEXT'
                else date['alt_ereignis'] + ' ' + date['datierung'] 
                for date in get_rel_datierung()] 
    # control ermitteln und text einfügen
    lbl_return_datierung = local_dialog.findChild(QLabel, 'lbl_return_datierung')
    lbl_return_datierung.setText(' | '.join(datierung))
    
# Feld: Nutzung / Funktion ############################################
    nutzung = [rel['nutzungsart'] + ': ' + rel['datierung'] for rel in get_rel_nutzung()] 
    
    # control ermitteln und text einfügen
    lbl_return_nutzung = local_dialog.findChild(QLabel, 'lbl_return_nutzung')
    lbl_return_nutzung.setText(' | '.join(nutzung))
    
# Feld: Personen #####################################################
    personen = [rel['ref_funktion'] + ': ' + rel['bezeichnung'] 
                if rel['ref_funktion'] != 'FREITEXT'
                else rel['alt_funktion'] + ': ' + rel['bezeichnung'] 
                for rel in get_rel_personen()] 
    
    # control ermitteln und text einfügen
    lbl_return_personen = local_dialog.findChild(QLabel, 'lbl_return_personen')
    lbl_return_personen.setText(' | '.join(personen))
    
# Feld: Erfasser #####################################################
    erfasser = list()
    for rel in get_rel_erfasser():
        if rel['id'] is not None:
            erfasser.append(rel['erfasser_name'] + ' (Ersteller:in)' if rel['is_creator'] else rel['erfasser_name'])

    # control ermitteln und text einfügen
    lbl_return_erfasser = local_dialog.findChild(QLabel, 'lbl_return_erfasser')
    lbl_return_erfasser.setText(', '.join(erfasser))        

# Feld: Blickbeziehung ###############################################
    blick = [rel['ref_blick'] + ' -> Objekt ' + str(rel['rel_objekt_nr']) + ': ' + rel['beschreibung']
            if rel['rel_objekt_nr'] is not None
            else rel['ref_blick'] + ': ' + rel['beschreibung']
            for rel in get_rel_blickbeziehung()]
    # control ermitteln und text einfügen
    lbl_return_blickbeziehung = local_dialog.findChild(QLabel, 'lbl_return_blickbeziehung')
    lbl_return_blickbeziehung.setText(' | '.join(blick))

# Feld: Sachbegriff ###########################################################
    sachbegriff = str()
    if local_feature.attribute('sachbegriff') is not None:        
        for feat in sachbegriffe:
            if str(feat['id']) == str(local_feature.attribute('sachbegriff')):
                if feat['sachbegriff'] == 'FREITEXT':
                    sachbegriff = '* ' + str(local_feature['sachbegriff_alt'])
                elif str(feat['sachbegriff_ueber']) == 'NULL':
                    sachbegriff = '[Kat.' + str(feat['kategorie']) + '] ' + feat['sachbegriff']
                else:
                    sachbegriff = '[Kat.' + str(feat['kategorie']) + '] ' + str(feat['sachbegriff_ueber']) + ' > ' + feat['sachbegriff']
    
    # control ermitteln und text einfügen
    lbl_sachbegriff = local_dialog.findChild(QLabel, 'lbl_sachbegriff')
    lbl_sachbegriff.setText(sachbegriff)

# Feld: Bilder ################################################################
    bilder = list()
    for rel in get_rel_bilder():
        # status = (' ✔  ' if requests.head(url_laudata + rel['dateiname']).ok else ' ❌  ')
        status = ' '
        if rel['titelbild'] and rel['intern']:
            bilder.append(status + rel['dateiname'] + ' (Titelbild, intern)')
        elif rel['intern']:
            bilder.append(status + rel['dateiname'] + ' (intern)')
        elif rel['titelbild']:
            bilder.append(status + rel['dateiname'] + ' (Titelbild)')
        else:
            bilder.append(status + rel['dateiname'])
    # control ermitteln und text einfügen
    lbl_return_bilder = local_dialog.findChild(QLabel, 'lbl_return_bilder')
    lbl_return_bilder.setText('\n'.join(bilder))

# Feld: Literatur ###############################################
    literatur = [rel['literatur']
              for rel in get_rel_literatur()] 
    # control ermitteln und text einfügen
    lbl_return_literatur = local_dialog.findChild(QLabel, 'lbl_return_literatur')
    lbl_return_literatur.setText('\n'.join(literatur))

####################################################################################################
# Menueleiste
####################################################################################################
    
# wechselt Objektart zwischen Einzelobjekt und Objektbereich
def changetype_object(dialog):
    dlg = QMessageBox()
    dlg.setWindowTitle('Sicherheitsabfrage')
    dlg.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
    dlg.setIcon(QMessageBox.Warning)
    dlg.setText('Soll der Objekttyp wirklich gewechselt werden?\n\nVorsicht: Beim Wechsel von Einzelobjekten zu Objektbereichen gehen einzelobjekt-spezifische Inhalte verloren!\n\nDie Änderung wird nach dem Speichern wirksam.')
    if dlg.exec() == QMessageBox.Yes:
        # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
        local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('api'), 'CHANGE_TYPE')
        # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
        local_feature['api'] = 'CHANGE_TYPE'

####################################################################################################
# Menüleiste: Bildvorschau
####################################################################################################
    
# defines and opens a dialog to display thumbnails
def dlg_vorschau(dialog):    
    
    # initialise layout and controls        
    layout = QGridLayout()

    # set window title
    title = []
    title.append('Bildvorschau:')
    if local_feature.attribute('bezeichnung') is not None:
        title.append(str(local_feature.attribute('bezeichnung')))
    dialog.setWindowTitle(' '.join(title))

    # define window spacing
    layout.setHorizontalSpacing(10)
    layout.setVerticalSpacing(30)

    # iterate over interface items and add tiles to layout
    itemNr = 0
    if len(get_rel_bilder()) <= 6:
        modifier = 3
    elif len(get_rel_bilder()) <= 12:
        modifier = 4
    else:
        modifier = 5
    for rel in get_rel_bilder():
        add_tile_preview(layout, rel, itemNr, int(modifier))
        itemNr += 1

    dialog.setLayout(layout) 
    dialog.setModal(True)       # force clean dialog handling
    dialog.setMinimumSize(300, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################   

# builds a tile (vbox) consisting of a webView (for thumbnail display) and a button (with link to original image)
def add_tile_preview(layout, rel, itemNr, modifier):

    if rel is not None:

        vbox = QVBoxLayout()
        row = 0
        column = 0
        webView = QWebView()
        lbl_marker = QLabel()
        lbl_filename = QLabel()
        btn = QToolButton()

        # arrange items on 4 columns and n rows
        column = itemNr % modifier
        if (itemNr % modifier == 0):
            itemNr += 1
        row = math.ceil(itemNr / modifier) -1        

        # set image
        webView.setUrl(QUrl(url_laudata_tn + rel['dateiname']))
        webView.setFixedHeight(150)
        webView.setMinimumWidth(200)
    
        # set lbl_marker txt and alignment
        lbl_marker.setAlignment(QtCore.Qt.AlignCenter)
        if rel['intern']:
            lbl_marker.setText('intern')
        elif rel['titelbild']:
            lbl_marker.setText('Titelbild')

        # set lbl_filename text and alignment
        lbl_filename.setWordWrap(True)
        lbl_filename.setText(rel['dateiname'])

        # set button text and function
        btn.setText('Originalbild')
        try:
            btn.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn.clicked.connect(lambda: webbrowser.open(url_laudata + rel['dateiname'], new=0, autoraise=True))
    
        # add controls to layout
        vbox.addWidget(lbl_marker, QtCore.Qt.AlignCenter)
        vbox.addWidget(webView)
        vbox.addWidget(lbl_filename)
        vbox.addWidget(btn)    
        layout.addLayout(vbox, row, column)      

####################################################################################################
# Feld: Datierung
####################################################################################################

# datierung definition ermitteln
def get_def_datierung():
    # build dict based upon def_datierung. unfortunately one can't simply export all features at once    
   return ({"id":feat['id'], "bezeichnung":feat['bezeichnung']}
            for feat in definitionen 
            if feat['tabelle'] == 'def_datierung')

# aufgelöste Liste mit Datierungen ermitteln
def get_rel_datierung():
    rel_dates = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_datierung'), str):     
        rel_dates = [{'relation_id'     :rel['relation_id'],
                      'datierung'       :rel['datierung'],
                      'ref_ereignis'    :[item['bezeichnung'] for item in get_def_datierung() if item['id'] == rel['ref_ereignis_id']][0],
                      'alt_ereignis'    :rel['alt_ereignis']}
                     for rel in json.loads(local_feature.attribute('return_datierung'))]
    # [{"relation_id":,"datierung":"","ref_ereignis":"","alt_ereignis":""}]
    return rel_dates
    
####################################################################################################        

# defines and opens a dialog to edit the date list
def dlg_edit_datierung(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Datierung bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_datierung(dialog))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_datierung(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(4)
    table.setHorizontalHeaderLabels(['relation_id', 'Datierung', 'Ereignis', 'Ereignis (alternativ)'])
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for date in get_rel_datierung():
        add_row_datierung(table, date)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        

def add_row_datierung(table, date):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)
    
    # 2 cbx Ereignis (bei jeder Row vorhanden)
    cbx = QComboBox()
    cbx.addItems(item['bezeichnung'] for item in get_def_datierung())    
    table.setCellWidget(row, 2, cbx)
    
    if date is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(date['relation_id'])))
        # 1 Datierung
        table.setItem(row, 1, QTableWidgetItem(date['datierung']))
        # 2 set combobox value
        cbx.setCurrentText(date['ref_ereignis'])
        # 3 Datierung Custom
        table.setItem(row, 3, QTableWidgetItem(date['alt_ereignis']))
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_datierung(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # Ereignisart auflösen
        ref_ereignis_id = None
        for item in get_def_datierung():
            if item['bezeichnung'] == table.cellWidget(row, 2).currentText():
                ref_ereignis_id = item['id']
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'       : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                'datierung'         : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'ref_ereignis_id'   : ref_ereignis_id if ref_ereignis_id is not None else 'NULL',
                'alt_ereignis'      : table.item(row, 3).text() if table.item(row, 3) is not None else 'NULL'
                })                       
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_datierung'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_datierung'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
      
####################################################################################################
# Feld: Funktion / Nutzung
####################################################################################################

# Liste mit Funktionen ermitteln
def get_rel_nutzung():
    relations = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_nutzung'), str):     
        relations = [rel for rel in json.loads(local_feature.attribute('return_nutzung'))]
    # [{"relation_id":,"nutzungsart":"","datierung":""}]
    return relations
    
####################################################################################################        

# defines and opens a dialog to edit the nutzung list
def dlg_edit_nutzung(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Nutzung bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_nutzung(dialog))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_nutzung(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(3)
    table.setHorizontalHeaderLabels(['relation_id', 'Nutzungsart', 'Datum'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.Stretch)
    header.setSectionResizeMode(2, QHeaderView.ResizeToContents)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for rel in get_rel_nutzung():
        add_row_nutzung(table, rel)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        

def add_row_nutzung(table, rel):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)
     
    if rel is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(rel['relation_id'])))
        # 1 Datierung
        table.setItem(row, 1, QTableWidgetItem(rel['nutzungsart']))
        # 2 Datierung Custom
        table.setItem(row, 2, QTableWidgetItem(rel['datierung']))
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_nutzung(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'       : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                'nutzungsart'       : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'datierung'         : table.item(row, 2).text() if table.item(row, 2) is not None else 'NULL'
                })                       
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_nutzung'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_nutzung'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
    
####################################################################################################
# Feld: Personen
####################################################################################################

# datierung definition ermitteln
def get_def_personen():
    # build dict based upon def_datierung. unfortunately one can't simply export all features at once   
    return ({"id":feat['id'], "bezeichnung":feat['bezeichnung']} 
             for feat in definitionen 
             if feat['tabelle'] == 'def_personen')

# aufgelöste Liste mit Datierungen ermitteln
def get_rel_personen():
    rel_person = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_personen'), str):     
        rel_person = [{'relation_id'    :rel['relation_id'],
                      'bezeichnung'     :rel['bezeichnung'],
                      'ref_funktion'    :[item['bezeichnung'] for item in get_def_personen() if item['id'] == rel['ref_funktion_id']][0],
                      'alt_funktion'    :rel['alt_funktion'],
                      'is_sozietaet'    :rel['is_sozietaet']}
                     for rel in json.loads(local_feature.attribute('return_personen'))]
    return rel_person
    
####################################################################################################        

# defines and opens a dialog to edit the date list
def dlg_edit_personen(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Personen bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_personen(dialog))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_personen(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(5)
    table.setHorizontalHeaderLabels(['relation_id', 'Name / Bezeichnung', 'Funktion', 'Funktion (alternativ)', 'Sozietaet'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.Stretch)
    header.setSectionResizeMode(2, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(3, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(4, QHeaderView.ResizeToContents)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for rel in get_rel_personen():
        add_row_personen(table, rel)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(550, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        

def add_row_personen(table, rel):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)

    # 2 cbx Funktion (bei jeder Row vorhanden)
    cbx = QComboBox()
    cbx.addItems(item['bezeichnung'] for item in get_def_personen())    
    table.setCellWidget(row, 2, cbx)
    
    # 4 chk Sozietaet (bei jeder Row vorhanden)
    is_sozietaet = QTableWidgetItem()
    is_sozietaet.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
    is_sozietaet.setCheckState(Qt.Unchecked) 
    table.setItem(row, 4, is_sozietaet)
    
    if rel is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(rel['relation_id'])))
        # 1 Bezeichnung
        table.setItem(row, 1, QTableWidgetItem(rel['bezeichnung']))
        # 2 set combobox value
        cbx.setCurrentText(rel['ref_funktion'])
        # 3 Funktion alternativ
        table.setItem(row, 3, QTableWidgetItem(rel['alt_funktion']))
        # 4 set checkbox state
        is_sozietaet.setCheckState(Qt.Checked if rel['is_sozietaet'] else Qt.Unchecked) 
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_personen(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # funktionsart auflösen
        ref_funktion_id = None
        for item in get_def_personen():
            if item['bezeichnung'] == table.cellWidget(row, 2).currentText():
                ref_funktion_id = item['id']
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'       : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                'bezeichnung'       : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'ref_funktion_id'   : ref_funktion_id if ref_funktion_id is not None else 'NULL',
                'alt_funktion'      : table.item(row, 3).text() if table.item(row, 3) is not None else 'NULL',
                'is_sozietaet'      : True if table.item(row, 4).checkState() > 0 else False
                })           
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_personen'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_personen'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
      
####################################################################################################
# Feld: Erfasser:in
####################################################################################################
            
# Ermittelt def_erfasser Liste und ergänzt diese Liste um die übergebenen Werte
def get_rel_erfasser():   
    # build dict based upon def_erfasser. unfortunately one can't simply export all features at once
    rel_erfasser = list({'id':None, 
                     'objekt':None, 
                     'erfasser_id':feat['id'], 
                     'erfasser_name':feat['bezeichnung'],
                     'is_creator':None} 
            for feat in definitionen 
            if feat['tabelle'] == 'def_erfasser')
    
    return_erfasser = None
    # check if object isnt none
    if isinstance(local_feature.attribute('return_erfasser'), str):
        return_erfasser = json.loads(local_feature.attribute('return_erfasser'))
        # combine base data in rel_erfasser and this list
        for entry in return_erfasser:
            for rel in rel_erfasser:
                if int(rel['erfasser_id']) == int(entry['ref_erfasser_id']):
                    rel['id'] = entry['relation_id']
                    rel['is_creator'] = (True if entry['is_creator'] else False)
                rel['objekt'] = entry['ref_objekt_id'] 
    # return combined list
    return rel_erfasser

####################################################################################################

# defines and opens a dialog to edit the creator list
def dlg_edit_erfasser(dialog):
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise controls        
    layout = QFormLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    dialog.setWindowTitle('Erfasser:innen festlegen')
    
    # define signals 
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_erfasser(dialog))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
    
    # setup table    
    row = 0
    table.setColumnCount(5)
    table.setHorizontalHeaderLabels(['ID', 'Ausgewählt', 'Erfasser_ID', 'Name', 'Ist Ersteller:in'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(3, QHeaderView.Stretch)
    header.setSectionResizeMode(4, QHeaderView.ResizeToContents)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    table.setColumnHidden(2, True)
    
    # Erfasserliste 
    rel_erfasser = None
    rel_erfasser = get_rel_erfasser()
    table.setRowCount(len(rel_erfasser))
    for person in rel_erfasser:
        # by columns:
        # 0 id
        table.setItem(row, 0, QTableWidgetItem(str(person['id'])))
        # 1 selected (checkbox)
        selected = QTableWidgetItem()
        selected.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
        selected.setCheckState(Qt.Checked if person['id'] is not None else Qt.Unchecked) 
        table.setItem(row, 1, selected)
        # 2 erfasser_id
        table.setItem(row, 2, QTableWidgetItem(str(person['erfasser_id'])))
        # 3 fullname
        fullname = QTableWidgetItem(person['erfasser_name'])
        fullname.setFlags(fullname.flags() & ~Qt.ItemIsEditable)
        table.setItem(row, 3, fullname)
        # 4 is_creator (checkbox)
        is_creator = QTableWidgetItem()
        is_creator.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
        is_creator.setCheckState(Qt.Checked if person['is_creator'] else Qt.Unchecked) 
        table.setItem(row, 4, is_creator)
        # incr
        row += 1
    
    # setup layout & dialog
    table.resizeColumnsToContents()
    layout.addRow(table)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(400, 300)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_erfasser(dlg_erfasser):
    # find data table and prepare list
    table = dlg_erfasser.findChild(QTableWidget, 'tableWidget')
    return_erfasser = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # checkstate selected -> write data into list
        if table.item(row, 1).checkState() > 0:                     
            return_erfasser.append({
                    'relation_id'       : table.item(row, 0).text() if table.item(row, 0).text().isnumeric() else 'NULL',
                    'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                    'ref_erfasser_id'   : table.item(row, 2).text() if table.item(row, 2).text().isnumeric() else 'NULL',
                    'is_creator'        : True if table.item(row, 4).checkState() > 0 else False
                    })
    
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_erfasser'), json.dumps(return_erfasser))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_erfasser'] = json.dumps(return_erfasser)
    # Aktualisierung des Dialogs erzwingen
    reload_controls()
 
####################################################################################################
# Feld: Blickbeziehung
####################################################################################################

# datierung definition ermitteln
def get_def_blickbeziehung():
#    # load list with base data via definition layer
    return ({"id":feat['id'], "bezeichnung":feat['bezeichnung']}
             for feat in definitionen
             if feat['tabelle'] == 'def_blickbeziehung')

# aufgelöste Liste mit Blickbeziehungen ermitteln
def get_rel_blickbeziehung():
    rel_blick = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_blickbeziehung'), str):     
        rel_blick = [{'relation_id'         :rel['relation_id'],
                      'beschreibung'        :rel['beschreibung'],
                      'rel_objekt_nr'        :rel['rel_objekt_nr'],
                      'ref_blick'  :[item['bezeichnung'] for item in get_def_blickbeziehung() if item['id'] == rel['ref_blick_id']][0]
                      }
                     for rel in json.loads(local_feature.attribute('return_blickbeziehung'))]
    # [{"relation_id":,"beschreibung":"","rel_objekt_nr":"","ref_blick":""}]
    return rel_blick
    
####################################################################################################        

# defines and opens a dialog to edit the blickbeziehung list
def dlg_edit_blickbeziehung(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Blickbeziehung bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_blickbeziehung(dialog))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_blickbeziehung(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(4)
    table.setHorizontalHeaderLabels(['relation_id', 'Beschreibung', 'sichtbares Objekt (Nr)', 'Blickbeziehung'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.Stretch)
    header.setSectionResizeMode(2, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(3, QHeaderView.ResizeToContents)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for blick in get_rel_blickbeziehung():
        add_row_blickbeziehung(table, blick)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        

def add_row_blickbeziehung(table, blick):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)
    
    # 2 cbx Ereignis (bei jeder Row vorhanden)
    cbx = QComboBox()
    cbx.addItems(item['bezeichnung'] for item in get_def_blickbeziehung())    
    table.setCellWidget(row, 3, cbx)
    
    if blick is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(blick['relation_id'])))
        # 1 Beschreibung
        table.setItem(row, 1, QTableWidgetItem(blick['beschreibung']))
        # 2 Zielobjekt
        table.setItem(row, 2, QTableWidgetItem(blick['rel_objekt_nr']))
        # 3 set combobox value
        cbx.setCurrentText(blick['ref_blick'])
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_blickbeziehung(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # Ereignisart auflösen
        ref_blick_id = None
        for item in get_def_blickbeziehung():
            if item['bezeichnung'] == table.cellWidget(row, 3).currentText():
                ref_blick_id = item['id']
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'               : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'             : local_feature.attribute('objekt_id'),
                'beschreibung'              : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'rel_objekt_nr'             : table.item(row, 2).text() if table.item(row, 2) is not None else 'NULL',
                'ref_blick_id'              : ref_blick_id if ref_blick_id is not None else 'NULL'
                })                       
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_blickbeziehung'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_blickbeziehung'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
    
####################################################################################################
# Feld: Sachbegriff
####################################################################################################

# defines and opens a dialog to edit the blickbeziehung list
def dlg_edit_sachbegriff(dialog):    

    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qhbox_bottom = QHBoxLayout()
    form_left = QFormLayout()
    
    # table oberbegriff
    table_ober= QTableWidget()
    table_ober.setObjectName('table_ober') # for identification
    table_ober.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    
    # table erweiterter sachbegriff
    table_erw = QTableWidget()
    table_erw.setObjectName('table_erw') # for identification
    table_erw.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    
    # buttons
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    dialog.setWindowTitle('Sachbegriff auswählen')
    
    # form controls
    sachbegriff_alt = QLineEdit()
    sachbegriff_alt.setObjectName('sachbegriff_alt') # for identification
    sachbegriff_alt.setToolTip('Eingabefeld für FREITEXT-Sachbegriffe.')
    sachbegriff_alt.setText(str(local_feature['sachbegriff_alt']))
    alle_sachbegriffe = QCheckBox()
    alle_sachbegriffe.setToolTip('Sachbegriffe aller Kategorien anzeigen.')
    alle_sachbegriffe.setCheckState(Qt.Unchecked)

    # setup table oberbegriff
    table_ober.setColumnCount(2)
    table_ober.setHorizontalHeaderLabels(['id', 'Sachbegriff'])
    table_ober.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
    # setup erweiterter sachbegriff
    table_erw.setColumnCount(2)
    table_erw.setHorizontalHeaderLabels(['id', 'Sachbegriff'])
    table_erw.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
    # hide id columns
    table_ober.setColumnHidden(0, True)
    table_erw.setColumnHidden(0, True)
        
    fill_table_sachbegriff(dialog, table_ober, None, False)
    # define signals
    # dialog buttons accept
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_sachbegriff(dialog))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
    
    # left table clicked
    try:
        table_ober.cellClicked.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    table_ober.cellClicked.connect(lambda: 
        fill_table_sachbegriff(dialog, table_erw, table_ober, alle_sachbegriffe.isChecked()))
    # checkbox changed
    try:
        alle_sachbegriffe.stateChanged.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    alle_sachbegriffe.stateChanged.connect(lambda: 
        fill_table_sachbegriff(dialog, table_ober, None, alle_sachbegriffe.isChecked()))
            
    # setup layout & dialog
    qhbox.addWidget(table_ober, 1)
    qhbox.addWidget(table_erw, 1)
    form_left.setContentsMargins(6,12,6,12) # left, top, right, bottom
    form_left.addRow(QLabel('alle Sachbegriffe anzeigen:'), alle_sachbegriffe)
    form_left.addRow(QLabel('Sachbegriff alternativ:'), sachbegriff_alt)
    qhbox_bottom.addLayout(form_left)
    qhbox_bottom.addWidget(btn_box)    
    layout.addRow(qhbox)
    layout.addRow(qhbox_bottom)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()
    
####################################################################################################        
   
# schreibt die rows für beide sachbegriff-tabellen    
def fill_table_sachbegriff(dialog, dest_table, src_table, alle_sachbegriffe):
    # tabelle zurücksetzen
    dest_table.setRowCount(0)
    kategorie = str(local_dialog.findChild(QComboBox, 'kategorie').currentData())
    # invalide kategorie-werte abfangen
    if len(kategorie) > 2:
        error_dialog.showMessage('Der Wert *Kategorie* wurde nicht korrekt gesetzt. Es wird eine ungefilterte Sachbegriffsliste aufgerufen.')
        kategorie = None
    # wenn filter 'alle Sachbegriffe', kategorien nicht filtern
    if alle_sachbegriffe:
        kategorie = None
        
    # src_table None -> fill table_ober acc to kategorie (or not) AND anlage
    if src_table is None and kategorie is not None:
        # fill table_ober according to filter kategorie but without anlage
        for feat in sachbegriffe:
            if str(feat['kategorie']) == kategorie and feat['ref_sachbegriff_id'] == feat['id']:
                # übergeordnet
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem('[Kat.' + str(feat['kategorie']) + '] ' + str(feat['sachbegriff']) + ' (+)')    
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
            elif str(feat['kategorie']) == kategorie and str(feat['ref_sachbegriff_id']) == 'NULL':
                # alleinstehend
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem('[Kat.' + str(feat['kategorie']) + '] ' + str(feat['sachbegriff']))
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
            elif str(feat['kategorie']) == 'NULL':
                # FREITEXT
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem(str(feat['sachbegriff']))
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
    elif src_table is None and kategorie is None:
        # fill table_ober with neither filter kategorie nor anlage
        for feat in sachbegriffe:
            if str(feat['kategorie']) == 'NULL':
                # FREITEXT
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem(str(feat['sachbegriff']))
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
            elif feat['ref_sachbegriff_id'] == feat['id']:
                # übergeordnet
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem('[Kat.' + str(feat['kategorie']) + '] ' + str(feat['sachbegriff']) + ' (+)')    
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
            elif str(feat['ref_sachbegriff_id']) == 'NULL':
                # alleinstehend
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem('[Kat.' + str(feat['kategorie']) + '] ' + str(feat['sachbegriff']))
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
    elif src_table is not None:
        # fill table_unter according to ref but without filter anlage
        for feat in sachbegriffe:
            if str(feat['ref_sachbegriff_id']) == str(src_table.item(src_table.currentRow(),0).text()):
                row = dest_table.rowCount()
                dest_table.insertRow(row)
                sachbegriff = QTableWidgetItem(str(feat['sachbegriff']))
                sachbegriff.setFlags(sachbegriff.flags() & ~Qt.ItemIsEditable)
                dest_table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))
                dest_table.setItem(row, 1, sachbegriff)
                dest_table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
 
####################################################################################################        
   
# accept methode zur Übernahme geänderter Werte
def accept_edit_sachbegriff(dialog):
    # find data table and prepare list
    table_ober = dialog.findChild(QTableWidget, 'table_ober')
    table_erw = dialog.findChild(QTableWidget, 'table_erw')
    sachbegriff_alt = dialog.findChild(QLineEdit, 'sachbegriff_alt').text()
    
    return_value = int()
        
    # selektierte Tabelle und Item ermitteln
    if table_erw.currentRow() != -1:
        # id aus Tabelle 'erweitert Sachbegriff' auslesen
        return_value = table_erw.item(table_erw.currentRow(),0).text()        
    elif table_ober.currentRow() != -1:
        # id aus Tabelle 'Oberbegriff' auslesen
        return_value = table_ober.item(table_ober.currentRow(),0).text()
    else:
        # keine Selektion
        return_value = -1
    
    if return_value != -1:   
        # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
        local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('sachbegriff'), return_value)
        # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
        local_feature['sachbegriff'] = return_value
        # Aktualisierung des Hauptdialogs erzwingen

    # sachbegriff_alt stets übernehmen
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('sachbegriff_alt'), sachbegriff_alt)
    local_feature['sachbegriff_alt'] = sachbegriff_alt
    
    reload_controls()    
    
####################################################################################################
# Feld: Bilder
####################################################################################################

# Liste mit Bildern ermitteln
def get_rel_bilder():
    relations = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_bilder'), str):     
        relations = [rel for rel in json.loads(local_feature.attribute('return_bilder'))]
    return relations
    
####################################################################################################        

# defines and opens a dialog to edit the nutzung list
def dlg_edit_bilder(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_parse = QToolButton()
    btn_parse.setText('Einlesen')
    btn_parse.setToolTip('Liest den Text aus [bilder_anmerkung] ein, trennt nach [;] und fügt die Ergebnisse in die Tabelle ein.')
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Bilder bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_bilder(dialog))
    try:
        btn_parse.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_parse.clicked.connect(lambda: check_bilder(table))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_bilder(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(5)
    table.setHorizontalHeaderLabels(['relation_id', 'Dateiname', 'intern', 'Titelbild', 'online'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.Stretch)
    header.setSectionResizeMode(2, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(3, QHeaderView.ResizeToContents)
    header.setSectionResizeMode(4, QHeaderView.ResizeToContents)
        
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for rel in get_rel_bilder():
        add_row_bilder(table, rel)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_parse, btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()

####################################################################################################        

# prüft bilder_anmerkungen auf zu importierende Bildeinträge und fügt diese der Tabelle hinzu
def check_bilder(table):
    
    for bild in [bild.strip() for bild 
              in local_dialog.findChild(QLineEdit, 'bilder_anmerkung').text().split(';')]:
        add_row_bilder(table, {"relation_id": 'NULL',"dateiname":bild,"intern":False, "titelbild":False})
    
####################################################################################################        

def add_row_bilder(table, rel):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)
    
    # 2 chk intern (bei jeder Row vorhanden)
    intern = QTableWidgetItem()
    intern.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
    intern.setCheckState(Qt.Unchecked)
    table.setItem(row, 2, intern)  
    
    # 3 chk titelbild (bei jeder Row vorhanden)
    titel = QTableWidgetItem()
    titel.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
    titel.setCheckState(Qt.Unchecked)
    table.setItem(row, 3, titel)  
    
    # 4 chk image is online
    online = QTableWidgetItem()
    online.setFlags(Qt.NoItemFlags)
    table.setItem(row, 4, online)

    if rel is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(rel['relation_id'])))
        # 1 dateiname
        table.setItem(row, 1, QTableWidgetItem(rel['dateiname']))
        # 2 kennzeichen inten
        intern.setCheckState(Qt.Checked if rel['intern'] else Qt.Unchecked) 
        # 3 kennzeichen titelbild
        titel.setCheckState(Qt.Checked if rel['titelbild'] else Qt.Unchecked) 
        # 4 kennzeichen online
        online.setText('✔' if requests.head(url_laudata + rel['dateiname']).ok else '✖')
    elif row == 0:
        # 3 kennzeichen titelbild in erster row
        titel.setCheckState(Qt.Checked)
        
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_bilder(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'       : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                'dateiname'         : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'intern'            : True if table.item(row, 2).checkState() > 0 else False,
                'titelbild'         : True if table.item(row, 3).checkState() > 0 else False
                })                       
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_bilder'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_bilder'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
    
####################################################################################################
# Feld: Literatur
####################################################################################################

# Liste mit Literatur ermitteln
def get_rel_literatur():
    relations = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_literatur'), str):     
        relations = [rel for rel in json.loads(local_feature.attribute('return_literatur'))]
    # [{"relation_id":,"literatur":"","lib_ref":""}]
    return relations
    
####################################################################################################        

# defines and opens a dialog to edit the literatur list
def dlg_edit_literatur(dialog):    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    qvbox = QVBoxLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_add = QToolButton()
    btn_add.setText('+')
    btn_add.setToolTip('Leere Zeile einfügen.')
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
    btn_del.setToolTip('Markierte Zeile löschen.')
    btn_del.setFixedSize(22,22)
    dialog.setWindowTitle('Literatur / Quellen bearbeiten')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_literatur(dialog))
    try:
        btn_add.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    btn_add.clicked.connect(lambda: add_row_literatur(table, None))
    try:
        btn_del.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    # löscht die oberste, ausgewählte Zeile
    btn_del.clicked.connect(lambda: table.removeRow(table.selectedIndexes()[0].row()))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
       
    # setup table
    table.setColumnCount(3)
    table.setHorizontalHeaderLabels(['relation_id', 'Literatur / Quelle', 'Literaturverwaltung'])
    header = table.horizontalHeader()
    header.setSectionResizeMode(1, QHeaderView.Stretch)
    header.setSectionResizeMode(2, QHeaderView.ResizeToContents)
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    
    # iterate over interface items and add rows
    for rel in get_rel_literatur():
        add_row_literatur(table, rel)

    # setup layout & dialog
    qvbox.addWidget(btn_add)
    qvbox.addWidget(btn_del)
    qhbox.addLayout(qvbox)
    qhbox.addWidget(table)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()

####################################################################################################        

def add_row_literatur(table, rel):   
    # get new row number
    row = table.rowCount()
    table.insertRow(row)
      
    if rel is not None:
        # 0 relation_id
        table.setItem(row, 0, QTableWidgetItem(str(rel['relation_id'])))
        # 1 literaturangabe
        table.setItem(row, 1, QTableWidgetItem(rel['literatur']))
        # 2 lib referenz
        table.setItem(row, 2, QTableWidgetItem(rel['lib_ref']))
    
####################################################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_literatur(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # Werte in Liste übernehmen
        return_list.append({
                'relation_id'       : table.item(row, 0).text() 
                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
                'ref_objekt_id'     : local_feature.attribute('objekt_id'),
                'literatur'         : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
                'lib_ref'           : table.item(row, 2).text() if table.item(row, 2) is not None else 'NULL',
                })                       
            
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_literatur'), json.dumps(return_list))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_literatur'] = json.dumps(return_list)
    # Aktualisierung des Hauptdialogs erzwingen
    reload_controls()
    
####################################################################################################