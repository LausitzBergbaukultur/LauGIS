from PyQt5.QtCore import Qt
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QDialog, QToolButton, QListWidget, QFormLayout, QTableWidget, QDialogButtonBox, QTableWidgetItem, QAbstractScrollArea
from PyQt5.QtWidgets import *

isInit = False
local_feature = None
local_layer = None

def formOpen(dialog,layer,feature):
    global isInit
    global local_feature
    global local_layer
    local_feature = feature
    local_layer = layer
    ## not initialised but has actual feature?
    ## mitigates multiple calls
    if not isInit and len(feature.attributes()) > 0:
        
        ## interface übersetzen    
        rel_erfasser = get_rel_erfasser(feature.attribute('return_erfasser')) 
        ## Button für Erfasser-Dialog
        dlg_erfasser = QDialog() 
        btn_erfasser = dialog.findChild(QToolButton, 'btn_erfasser')
        try:
            btn_erfasser.disconnect()
        except:
            # Notwendig, da QGIS unerwartete, doppelte Aufrufe generiert
            print('Überzählige Instanziierung abgefangen')
        btn_erfasser.clicked.connect(lambda: edit_erfasser(dlg_erfasser, rel_erfasser))
        ### Erfasser Liste
        listWidget = dialog.findChild(QListWidget, 'listWidget')
        listWidget.clear()    
        for rel in rel_erfasser:
            if rel['id'] is not None:
                listWidget.addItem(rel['erfasser_name'] + ' (Ersteller:in)' if rel['is_creator'] else rel['erfasser_name'])

##############################################################################

# Ermittelt def_erfasser Liste und ergänzt diese Liste um die übergebenen Werte
def get_rel_erfasser(return_erfasser):
    rel_erfasser = []
    # get def_table
    project = QgsProject.instance()
    # TODO unscharfe namen ermöglichen
    def_erfasser = project.mapLayersByName('def_erfasser')[0]
    
    # def_erfasser als Basis übernehmen
    for entry in def_erfasser.getFeatures():
        new = dict()
        new['id'] = None
        new['objekt'] = None
        new['erfasser_id'] = entry.attribute('id')
        new['erfasser_name'] = entry.attribute('name')
        new['is_creator'] = None
        rel_erfasser.append(new)
    
    if return_erfasser is not None:
        # um Status aus übergebener Liste ergänzen
        for entry in return_erfasser:
            attributes = entry.strip('()').split(',')
            # in erfasser-liste eintragen
            for rel in rel_erfasser:
                if int(rel['erfasser_id']) == int(attributes[2]):
                    rel['id'] = attributes[0]
                    rel['is_creator'] = (True if attributes[3] == 't' else False)
                # ObjektId wird immer übernommen: entspricht Attribut
                rel['objekt'] = attributes[1]
    return rel_erfasser

###############################################################################

# defines and opens a dialog to edit the creator list
def edit_erfasser(dlg_erfasser, rel_erfasser):
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
        print('Überzählige Instanziierung abgefangen')
    dlg_erfasser.accepted.connect(lambda: edit_erfasser_accept(dlg_erfasser))
    
    # TODO editable abfragen
    # setup table    
    row = 0
    table.setColumnCount(6)
    table.setHorizontalHeaderLabels(['ID', 'Ausgewählt', 'Objekt_ID', 'Erfasser_ID', 'Name', 'Ist Ersteller:in'])
    #table.setColumnHidden(2, True)
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
    # find data table
    table = dlg_erfasser.findChild(QTableWidget, 'tableWidget')
    return_erfasser = list()
        
    for row in range(table.rowCount()):
        # checkstate selected
        if table.item(row, 1).checkState() > 0:
            relid = (table.item(row, 0).text() if table.item(row, 0).text().isnumeric() else 'NULL')
            objid = (table.item(row, 2).text() if table.item(row, 2).text().isnumeric() else 'NULL')
            erfid = (table.item(row, 3).text() if table.item(row, 3).text().isnumeric() else 'NULL')
            is_creator = ('t' if table.item(row, 5).checkState() > 0 else 'f') 
            
            # TODO das muss schöner gehen
            return_erfasser.append("(" + relid + "," + objid + "," + erfid + "," + is_creator + ")")
    
    # TODO "with" prüfen       
    #with edit(local_layer):
    local_layer.changeAttributeValue(local_feature.id(), local_layer.fields().indexOf('return_erfasser'), return_erfasser)
      
###############################################################################    
    
    
    
    
    
    
    
    
    
    
    
    
        ## initialise custom controls    
        
        # build layout
        #liste = [{1,2,3,}, {4,5,6,}, {7,8,9,0}]
        #liste = ["(1,2,3,)", "(4,5,6,)", "(7,8,9,0)"]
        
    
        # build table inventory
    
        # initialise layout



 #layout.addWidget(table)
        
        #for r, (entry, obj, erfasser, flag) in enumerate(feature.attribute('return_erfasser')):
        #for r, entry in enumerate(feature.attribute('return_erfasser')):
        #for entry in feature.attribute('return_erfasser'):
         #   print(entry)
          #  it_1 = QTableWidgetItem()
           # it_1.setFlags(it_1.flags() | QtCore.Qt.ItemIsUserCheckable)
            #it_1.setCheckState(QtCore.Qt.Unchecked)
            #it_2 = QTableWidgetItem(entry)
            #table.insertRow(table.rowCount())
            #table.insertRow(entry)
            #for c, item in enumerate([it_1, it_2]):
            #    table.setItem(r, c, item)     
    
## Initialise form and controls        
#def init():
    #print('initialising form...')
    #isInit = True
    
    
    #print(myFeature.attribute('return_erfasser'))
    #global listWidget
    # clear values
    
    
    #listWidget.addItems(['stuff2','2'])
    
    
    #global tableView
    #global lineEdit_id
    #global lineEdit_user
    
    #print(myLayer.dataProvider.attributes)
        
    
    #tableView = myDialog.findChild(QTableView, 'tableView')
    
    #lineEdit_id = myDialog.findChild(QLineEdit, 'lineEdit_id')
    #lineEdit_user = myDialog.findChild(QLineEdit, 'lineEdit_user')
    
    #btn_add = myDialog.findChild(QPushButton, 'btn_addstamp')
    #btn_add.clicked.connect(addStamp)
    #bezLabel = dialog.findChild(QLabel, 'lbl_bezeichnung')
        
    #btn = dialog.findChild(QPushButton, 'pushButton')
    #btn.clicked.connect(buttonClick)
    
    #print(bezLabel.text())
    #bezLabel.setText('geaendert')
    #bezLabel.text = "Bez123"
    #bezLabel.enabled = False
    
    #le = myDialog.findChild(QLineEdit, 'lneEdit')
   # le.text = "123"
    #le.setStyleSheet("background-color: rgba(255, 107, 107, 150);")
    
    #bezField = dialog.findChild(QLineEdit, "bezeichnung")
    #bezField.setStyleSheet("background-color: rgba(255, 107, 107, 150);")
     
    
###############################################################################

#def addStamp():
    
    #form2 = QDialog()
    #form2.show()
    
    #fk_doc = lineEdit_id.text()
    #fk_erf = lineEdit_user.text()
    #query = con.exec('INSERT INTO development.ref_edithistory(fk_doc, fk_erf, "timestamp") VALUES (' + fk_doc + ', ' + fk_erf + ', NOW());')    
    #print(query)
    #query = None

###############################################################################
    