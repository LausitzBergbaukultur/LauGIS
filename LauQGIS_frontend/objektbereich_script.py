from PyQt5.QtCore import Qt
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QDialog, QToolButton, QListWidget, QFormLayout, QTableWidget, QDialogButtonBox, QTableWidgetItem, QAbstractScrollArea, QRadioButton, QErrorMessage, QLabel, QHBoxLayout, QVBoxLayout, QComboBox, QHeaderView
from PyQt5.QtWidgets import *
import json

error_dialog = QErrorMessage()
local_feature = None
local_layer = None
local_dialog = None

def formOpen(dialog,layer,feature):
    # Scope: Zugriff auf relevante Ressourcen ermöglichen
    global local_feature
    global local_layer
    global local_dialog
    global error_dialog
    local_feature = feature
    local_layer = layer
    local_dialog = dialog
    
    ## check if initialised with actual feature
    if len(feature.attributes()) > 0:
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
        sachbegriff = QDialog()
        btn_sachbegriff = local_dialog.findChild(QToolButton, 'btn_sachbegriff')
        try:
            btn_sachbegriff.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_sachbegriff.clicked.connect(lambda: dlg_edit_sachbegriff(sachbegriff))

##############################################################################

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
            if rel['rel_objekt_nr'] is not None #or rel['rel_objekt_nr'] != 'NULL'
            else rel['ref_blick'] + ': ' + rel['beschreibung']
            for rel in get_rel_blickbeziehung()]
    # control ermitteln und text einfügen
    lbl_return_blickbeziehung = local_dialog.findChild(QLabel, 'lbl_return_blickbeziehung')
    lbl_return_blickbeziehung.setText(' | '.join(blick))

# Feld: Sachbegriff ###############################################
        
    # load definition layer
    project = QgsProject.instance()
    def_sachbegriffe = QgsVectorLayer()
    try:
        def_sachbegriffe = project.mapLayersByName('def_sachbegriffe')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_sachbegriffe* konnte nicht gefunden werden.')
    
    # auf id filtern
    def_sachbegriffe.setSubsetString("ID = " + str(local_feature.attribute('sachbegriff')))    
    
    sachbegriff = ['[Kat.' + str(feat['kategorie']) + '] ' + feat['sachbegriff_ueber'] + ' > ' + feat['sachbegriff']
            for feat in def_sachbegriffe.getFeatures()]
    
    # filter auflösen
    def_sachbegriffe.setSubsetString("")   
    
    # control ermitteln und text einfügen
    lbl_sachbegriff = local_dialog.findChild(QLabel, 'lbl_sachbegriff')
    lbl_sachbegriff.setText(sachbegriff[0])


##############################################################################
# Feld: Datierung
##############################################################################

# datierung definition ermitteln
def get_def_datierung():
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_datierung = QgsVectorLayer()
    try:
        def_datierung = project.mapLayersByName('def_datierung')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_datierung* konnte nicht gefunden werden.')
    # build dict based upon def_datierung. unfortunately one can't simply export all features at once
    return [{"id":feat['id'], "bezeichnung":feat['bezeichnung']} for feat in def_datierung.getFeatures()]

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
    
###############################################################################        

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
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
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
    #TODO reset table at reject
       
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
    
###############################################################################        

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
    
###############################################################################        
    
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
      
##############################################################################
# Feld: Funktion / Nutzung
##############################################################################

# Liste mit Funktionen ermitteln
def get_rel_nutzung():
    relations = list()
    # check if object isnt none
    if isinstance(local_feature.attribute('return_nutzung'), str):     
        relations = [rel for rel in json.loads(local_feature.attribute('return_nutzung'))]
    # [{"relation_id":,"nutzungsart":"","datierung":""}]
    return relations
    
###############################################################################        

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
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
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
    #TODO reset table at reject
       
    # setup table
    table.setColumnCount(3)
    table.setHorizontalHeaderLabels(['relation_id', 'Nutzungsart', 'Datum'])
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
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
    
###############################################################################        

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
    
###############################################################################        
    
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
    
##############################################################################
# Feld: Personen
##############################################################################

# datierung definition ermitteln
def get_def_personen():
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_personen = QgsVectorLayer()
    try:
        def_personen = project.mapLayersByName('def_personen')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_personen* konnte nicht gefunden werden.')
    # build dict based upon def_datierung. unfortunately one can't simply export all features at once
    return [{"id":feat['id'], "bezeichnung":feat['bezeichnung']} for feat in def_personen.getFeatures()]

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
    # [{"relation_id":,"bezeichnung":"","ref_funktion":"","alt_funktion":"", "is_sozietaet":bool}]
    return rel_person
    
###############################################################################        

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
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
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
    #TODO reset table at reject
       
    # setup table
    table.setColumnCount(5)
    table.setHorizontalHeaderLabels(['relation_id', 'Name / Bezeichnung', 'Funktion', 'Funktion (alternativ)', 'Sozietaet'])
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
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
    
###############################################################################        

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
    
###############################################################################        
    
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
      
    
##############################################################################
# Feld: Erfasser:in
##############################################################################
            
# Ermittelt def_erfasser Liste und ergänzt diese Liste um die übergebenen Werte
def get_rel_erfasser():
    # return variable to fill
    rel_erfasser = list()
    
    # TODO list for all def tables
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_erfasser = QgsVectorLayer()
    
    try:
        def_erfasser = project.mapLayersByName('def_erfasser')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_erfasser* konnte nicht gefunden werden.')
    
    # build dict based upon def_erfasser. unfortunately one can't simply export all features at once
    rel_erfasser = [{'id':None, 
                     'objekt':None, 
                     'erfasser_id':feat['id'], 
                     'erfasser_name':feat['name'],
                     'is_creator':None} for feat in def_erfasser.getFeatures()]
        
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

###############################################################################

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
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
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
        #TODO tf?
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
    
###############################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_erfasser(dlg_erfasser):
    # find data table and prepare list
    table = dlg_erfasser.findChild(QTableWidget, 'tableWidget')
    return_erfasser = list()
    return_erfasser.clear()
    
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
 
##############################################################################
# Feld: Blickbeziehung
##############################################################################

# datierung definition ermitteln
def get_def_blickbeziehung():
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_blickbeziehung = QgsVectorLayer()
    try:
        def_blickbeziehung = project.mapLayersByName('def_blickbeziehung')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_blickbeziehung* konnte nicht gefunden werden.')
    # build dict based upon def_blickbeziehung. unfortunately one can't simply export all features at once
    return [{"id":feat['id'], "bezeichnung":feat['bezeichnung']} for feat in def_blickbeziehung.getFeatures()]

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
    
###############################################################################        

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
    btn_add.setFixedSize(22,22)
    btn_del = QToolButton()
    btn_del.setText('-')
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
    #TODO reset table at reject
       
    # setup table
    table.setColumnCount(4)
    table.setHorizontalHeaderLabels(['relation_id', 'Beschreibung', 'sichtbares Objekt (Nr)', 'Blickbeziehung'])
    table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
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
    
###############################################################################        

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
    
###############################################################################        
    
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
    
##############################################################################
# Feld: Sachbegriff
##############################################################################

# defines and opens a dialog to edit the blickbeziehung list
def dlg_edit_sachbegriff(dialog):    

    # load definition layer
    project = QgsProject.instance()
    def_sachbegriffe = QgsVectorLayer()
    try:
        def_sachbegriffe = project.mapLayersByName('def_sachbegriffe')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_sachbegriffe* konnte nicht gefunden werden.')
    
    # check edit state    
    if local_layer.isEditable():
        dialog.setDisabled(False)
    else:
        dialog.setDisabled(True)
    
    # initialise layout and controls        
    layout = QFormLayout()
    qhbox = QHBoxLayout()
    # table oberbegriff
    table_ober= QTableWidget()
    table_ober.setObjectName('table_ober') # for identification
    table_ober.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    # table erweiterter sachbegriff
    table_erw = QTableWidget()
    table_erw.setObjectName('table_erw') # for identification
    table_erw.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    dialog.setWindowTitle('Sachbegriff auswählen')

    # define signals
    try:
        dialog.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dialog.accepted.connect(lambda: accept_edit_sachbegriff(dialog))
    btn_box.accepted.connect(dialog.accept)
    btn_box.rejected.connect(dialog.reject)
    
    try:
        table_ober.cellClicked.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    #filter2 =  
    table_ober.cellClicked.connect(lambda: 
        fill_table_sachbegriff(def_sachbegriffe, table_erw, "ref_sachbegriff_id = " + str(table_ober.item(table_ober.currentRow(),0).text())))
        
    # setup table oberbegriff
    table_ober.setColumnCount(2)
    table_ober.setHorizontalHeaderLabels(['id', 'Sachbegriff'])
    table_ober.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
    # setup erweiterter sachbegriff
    table_erw.setColumnCount(2)
    table_erw.setHorizontalHeaderLabels(['id', 'Sachbegriff'])
    table_erw.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
    
    # hide irrelevant columns
    table_ober.setColumnHidden(0, True)
    table_erw.setColumnHidden(0, True)
    
    # fill table oberbegriff
    filter_ober = "(id = ref_sachbegriff_id OR ref_sachbegriff_id IS NULL) AND kategorie = " + str(local_feature.attribute('kategorie'))
    fill_table_sachbegriff(def_sachbegriffe, table_ober, filter_ober)
    
    # setup layout & dialog
    qhbox.addWidget(table_ober)
    qhbox.addWidget(table_erw)
    layout.addRow(qhbox)
    layout.addRow(btn_box)
    dialog.setLayout(layout) 
    dialog.setModal(True)       # ensure clean dialog handling
    dialog.setMinimumSize(450, 200)
    dialog.show()
    dialog.adjustSize()
    
###############################################################################        
   
def fill_table_sachbegriff(def_sachbegriffe, table, tablefilter):
    
    # tabelle zurücksetzen
    table.setRowCount(0)
    
    # filter setzen  
    def_sachbegriffe.setSubsetString(tablefilter)    
    
    # rows einfügen
    for feat in def_sachbegriffe.getFeatures():
        row = table.rowCount()
        table.insertRow(row)
        # 0 id
        table.setItem(row, 0, QTableWidgetItem(str(feat['id'])))     
        # 1 Sachbegriff
        if feat['ref_sachbegriff_id'] == feat['id'] and table.objectName() == 'table_ober':
            table.setItem(row, 1, QTableWidgetItem(feat['sachbegriff'] + ' (+)'))
        else:
            table.setItem(row, 1, QTableWidgetItem(feat['sachbegriff']))
    
    # filter auflösen
    def_sachbegriffe.setSubsetString("")   
 
###############################################################################        
   
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_sachbegriff(dialog):
    # find data table and prepare list
    table_ober = dialog.findChild(QTableWidget, 'table_ober')
    table_erw = dialog.findChild(QTableWidget, 'table_erw')
    
    return_value = int()
        
    if table_erw.currentRow() != -1:
        #print('erweitert: ' + str(table_erw.item(table_erw.currentRow(),1).text()))
        return_value = table_erw.item(table_erw.currentRow(),0).text()        
    else:
        #print('oberbegriff: ' + str(table_ober.item(table_ober.currentRow(),1).text()))
        return_value = table_ober.item(table_erw.currentRow(),0).text()

    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('sachbegriff'), return_value)
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['sachbegriff'] = return_value
    reload_controls()    
        
#    # parse table entries into return list
#    for row in range(table.rowCount()):
#        # Ereignisart auflösen
#        ref_blick_id = None
#        for item in get_def_blickbeziehung():
#            if item['bezeichnung'] == table.cellWidget(row, 3).currentText():
#                ref_blick_id = item['id']
#        # Werte in Liste übernehmen
#        return_list.append({
#                'relation_id'               : table.item(row, 0).text() 
#                    if table.item(row, 0) is not None and table.item(row, 0).text().isnumeric() else 'NULL',
#                'ref_objekt_id'             : local_feature.attribute('objekt_id'),
#                'beschreibung'              : table.item(row, 1).text() if table.item(row, 1) is not None else 'NULL',
#                'rel_objekt_nr'             : table.item(row, 2).text() if table.item(row, 2) is not None else 'NULL',
#                'ref_blick_id'              : ref_blick_id if ref_blick_id is not None else 'NULL'
#                })                       
#     
#    print(return_value)

#    #local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_blickbeziehung'), json.dumps(return_list))
#    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
#    #local_feature['return_blickbeziehung'] = json.dumps(return_list)
#    # Aktualisierung des Hauptdialogs erzwingen

    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    