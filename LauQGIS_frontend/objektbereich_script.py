from PyQt5.QtCore import Qt
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QDialog, QToolButton, QListWidget, QFormLayout, QTableWidget, QDialogButtonBox, QTableWidgetItem, QAbstractScrollArea, QRadioButton, QErrorMessage, QLabel, QHBoxLayout, QVBoxLayout, QComboBox
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
    
    ## not initialised but has actual feature?
    ## mitigates multiple calls
    if len(feature.attributes()) > 0:
        # load all custom controls
        reload_controls()
        # modal dialog for all edit windows
        dlg_edit = QDialog()
            
# Feld: Datierung #####################################################        
        btn_datierung = local_dialog.findChild(QToolButton, 'btn_datierung')
        try:
            btn_datierung.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_datierung.clicked.connect(lambda: dlg_edit_datierung(dlg_edit))
        
# Feld: Erfasser ######################################################
        btn_erfasser = dialog.findChild(QToolButton, 'btn_erfasser')
        try:
            btn_erfasser.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_erfasser.clicked.connect(lambda: dlg_edit_erfasser(QDialog()))

# Feld: Personen ######################################################
        load_person_control()

##############################################################################

# refresh list on primary dialog
def reload_controls():

# Feld: Datierung #####################################################
    datierung = [date['ref_ereignis'] + ' ' + date['datierung'] for date in get_rel_datierung()] 
                #if date['ref_ereignis'] is not 'FREITEXT' else date['alt_ereignis'] + ' ' + date['datierung']]
    # TODO ELSE
    # control ermitteln und text einfügen
    lbl_return_datierung = local_dialog.findChild(QLabel, 'lbl_return_datierung')
    lbl_return_datierung.setText(' | '.join(datierung))
    
# Feld: Erfasser #####################################################
    erfasser = list()
    for rel in get_rel_erfasser():
        if rel['id'] is not None:
            erfasser.append(rel['erfasser_name'] + ' (Ersteller:in)' if rel['is_creator'] else rel['erfasser_name'])
    # control ermitteln und text einfügen
    lbl_return_erfasser = local_dialog.findChild(QLabel, 'lbl_return_erfasser')
    lbl_return_erfasser.setText(', '.join(erfasser))        


# TODO später
#def checkControlDefaults():
#    aenderungsdatum = local_dialog.findChild(QgsDateTimeEdit, 'aenderungsdatum')
#    print(aenderungsdatum)
#    #for child in local_dialog.children():
#     #   if type(child) is QLineEdit:
#      #      print('found one')
#            # and child.text == 'NULL':
#       #     child.setText('')

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
        rel_dates = [{'relation_id'     :date['relation_id'],
                      'datierung'       :date['datierung'],
                      'ref_ereignis'    :[item['bezeichnung'] for item in get_def_datierung() if item['id'] == date['ref_ereignis_id']][0],
                      'alt_ereignis'    :date['alt_ereignis']}
                     for date in json.loads(local_feature.attribute('return_datierung'))]
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
    btn_del = QToolButton()
    btn_del.setText('-')
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
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    
    # TODO hide irrelevant columns
    #table.setColumnHidden(0, True)
    
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
    dialog.show()
    table.resizeColumnsToContents()
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
    
    table.resizeColumnsToContents()
    
###############################################################################        
    
# accept methode zur Übernahme geänderter Werte
def accept_edit_datierung(dialog):
    # find data table and prepare list
    table = dialog.findChild(QTableWidget, 'tableWidget')
    return_list = list()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        #print(table.cellWidget(row, 2).currentText())
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
    dialog.setModal(True)
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
# Feld: Personen
##############################################################################

# fill datierung control
def load_person_control():
    # mock interface
    return_person = [{"id" :  1, "date" : "ab 1905", "function" : "Auftraggeber:in", "function_custom" : None, "is_real" : True}
                    , {"id" :  2, "date" : "1980-1983", "function" : "Bauleitung", "function_custom" : None, "is_real" : True}
                    , {"id" :  3, "date" : "13.02.1961", "function" : "Entwurf", "function_custom" : None, "is_real" : False}]
        
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_personen = QgsVectorLayer()
    try:
        def_datierung = project.mapLayersByName('def_personen')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_personen* konnte nicht gefunden werden.')
    # build dict based upon def_datierung. unfortunately one can't simply export all features at once
    personen = [{"id" :  feat['id'], "bezeichnung" : feat['bezeichnung']} for feat in def_datierung.getFeatures()]
    
    # define table
    tbl_datierung = local_dialog.findChild(QTableWidget, 'personen')
    tbl_datierung.setColumnCount(4)
    tbl_datierung.setHorizontalHeaderLabels(['ID', 'Datum', 'Funktion', 'Funktion Custom'])
    tbl_datierung.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    
    # iterate table items
    row = 0
    tbl_datierung.setRowCount(len(return_person))
    for person in return_person:
        # by columns:
        # 0 id
        relid = QTableWidgetItem(str(person['id']))
        tbl_datierung.setItem(row, 0, relid)
        # 1 Datum
        datum = QTableWidgetItem(str(person['date']))
        tbl_datierung.setItem(row, 1, datum)
        # 2 Datierung Bezeichnung
        cbx = QComboBox()
        cbx.addItems(item['bezeichnung'] for item in personen)
        # set defined value
        cbx.setCurrentText(str(person['function']))
        tbl_datierung.setCellWidget(row, 2, cbx)
        # 3 Datierung Custom
        custom = QTableWidgetItem(str(person['function_custom']))
        tbl_datierung.setItem(row, 3, custom)
        # incr
        row += 1
    tbl_datierung.resizeColumnsToContents()
    
##############################################################################
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    