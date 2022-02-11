from PyQt5.QtCore import Qt
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QDialog, QToolButton, QListWidget, QFormLayout, QTableWidget, QDialogButtonBox, QTableWidgetItem, QAbstractScrollArea, QRadioButton, QErrorMessage
#from PyQt5.QtWidgets import *
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
        
        ## Button für Erfasser-Dialog
        load_erfasser_control()
        dlg_erfasser = QDialog()
        
        btn_erfasser = dialog.findChild(QToolButton, 'btn_erfasser')
        
        try:
            btn_erfasser.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            True
        btn_erfasser.clicked.connect(lambda: dlg_edit_erfasser(dlg_erfasser))

##############################################################################
# Feld: Erfasser:in
##############################################################################

# refresh list on primary dialog
def load_erfasser_control():
    # control ermitteln
    # TODO eindeutigen namen vergeben
    listWidget = local_dialog.findChild(QListWidget, 'listWidget')
    listWidget.clear()
    # relation list ermitteln
    for rel in get_rel_erfasser():
        if rel['id'] is not None:
            listWidget.addItem(rel['erfasser_name'] + ' (Ersteller:in)' if rel['is_creator'] else rel['erfasser_name'])

##############################################################################
            
# Ermittelt def_erfasser Liste und ergänzt diese Liste um die übergebenen Werte
def get_rel_erfasser():
    # return variable to fill
    rel_erfasser = list()
    
    # load list with base data via definition layer
    project = QgsProject.instance()
    def_erfasser = QgsVectorLayer()
    try:
        def_erfasser = project.mapLayersByName('def_erfasser')[0]
    except:
        error_dialog.showMessage('Der Definitionslayer *def_erfasser* konnte nicht gefunden werden.')
    
    # def_erfasser als Basis übernehmen
    for entry in def_erfasser.getFeatures():
        new = dict()
        new['id'] = None
        new['objekt'] = None
        new['erfasser_id'] = entry.attribute('id')
        new['erfasser_name'] = entry.attribute('name')
        new['is_creator'] = None
        rel_erfasser.append(new)
    
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
def dlg_edit_erfasser(dlg_erfasser):#, rel_erfasser):
    # check edit state    
    if local_layer.isEditable():
        dlg_erfasser.setDisabled(False)
    else:
        dlg_erfasser.setDisabled(True)
    
    # define controls        
    layout = QFormLayout()
    table = QTableWidget()
    table.setObjectName('tableWidget') # for identification
    table.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
    btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)    
    btn_box.accepted.connect(dlg_erfasser.accept)
    btn_box.rejected.connect(dlg_erfasser.reject)
    try:
        dlg_erfasser.disconnect()
    except:
        # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
        True
    dlg_erfasser.accepted.connect(lambda: edit_erfasser_accept(dlg_erfasser))
    
    # setup table    
    row = 0
    table.setColumnCount(6)
    table.setHorizontalHeaderLabels(['ID', 'Ausgewählt', 'Objekt_ID', 'Erfasser_ID', 'Name', 'Ist Ersteller:in'])
    
    # hide irrelevant columns
    table.setColumnHidden(0, True)
    table.setColumnHidden(2, True)
    table.setColumnHidden(3, True)
    
    # Erfasserliste 
    rel_erfasser = None
    rel_erfasser = get_rel_erfasser()
    table.setRowCount(len(rel_erfasser))
    for person in rel_erfasser:
        # by columns:
        # 0 id
        relid = QTableWidgetItem(str(person['id']))
        table.setItem(row, 0, relid)
        # 1 selected (checkbox)
        selected = QTableWidgetItem()
        selected.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
        selected.setCheckState(Qt.Checked if person['id'] is not None else Qt.Unchecked) 
        table.setItem(row, 1, selected)
        # 2 objekt_ID
        objid = QTableWidgetItem(str(person['objekt']))
        table.setItem(row, 2, objid)
        # 3 erfasser_id
        erfid = QTableWidgetItem(str(person['erfasser_id']))
        table.setItem(row, 3, erfid)
        # 4 fullname
        fullname = QTableWidgetItem(str(person['erfasser_name']))
        fullname.setFlags(fullname.flags() & ~Qt.ItemIsEditable)
        table.setItem(row, 4, fullname)
        # 5 is_creator (checkbox)
        is_creator = QTableWidgetItem()
        is_creator.setFlags(Qt.ItemIsUserCheckable | Qt.ItemIsEnabled)
        is_creator.setCheckState(Qt.Checked if person['is_creator'] else Qt.Unchecked) 
        table.setItem(row, 5, is_creator)
        # incr
        row += 1
    
    # setup layout & dialog
    table.resizeColumnsToContents()
    layout.addRow(table)
    layout.addRow(btn_box)
    dlg_erfasser.setLayout(layout) 
    dlg_erfasser.setWindowTitle('Erfasser:innen festlegen')
    dlg_erfasser.show()
    dlg_erfasser.adjustSize()
    
###############################################################################        
    
# accept methode zur Übernahme geänderter Werte
def edit_erfasser_accept(dlg_erfasser):
    # find data table and prepare list
    table = dlg_erfasser.findChild(QTableWidget, 'tableWidget')
    return_erfasser = list()
    return_erfasser.clear()
    
    # parse table entries into return list
    for row in range(table.rowCount()):
        # checkstate selected -> write data into list
        if table.item(row, 1).checkState() > 0:                     
            return_erfasser.append({
                    'relation_id' : table.item(row, 0).text() if table.item(row, 0).text().isnumeric() else 'NULL',
                    'ref_objekt_id' : table.item(row, 2).text() if table.item(row, 2).text().isnumeric() else 'NULL',
                    'ref_erfasser_id' : table.item(row, 3).text() if table.item(row, 3).text().isnumeric() else 'NULL',
                    'is_creator' : True if table.item(row, 5).checkState() > 0 else False
                    })
                       
    # speichern auf Layerebene, nur so werden bestehende Objekte aktualisiert
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_erfasser'), json.dumps(return_erfasser))
    # speichern auf Featureebene, nur so werden neue Objekte aktualisiert
    local_feature['return_erfasser'] = json.dumps(return_erfasser)
    # Aktualisierung des Dialogs erzwingen
    load_erfasser_control()
    
###############################################################################    
      
    