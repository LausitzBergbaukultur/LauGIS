#from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
#from PyQt5.QtSql import QSqlDatabase, QSqlTableModel , QSqlQuery

#myDialog = None
#myLayer = None
#myFeature = None # qgis._core.QgsFeature

#listWidget = None
#tableView = None
#lineEdit_id = None
#lineEdit_user = None

isInit = False

def formOpen(dialog,layer,feature):
    global isInit

    ## not initialised but has actual feature?
    ## mitigates multiple calls
    if not isInit and len(feature.attributes()) > 0:
        #global myDialog
        #myDialog = dialog
        #global myLayer
        #myLayer = layer
        #global myFeature
        #myFeature = feature
        #init()
        
        ## initialise custom controls
        listWidget = dialog.findChild(QListWidget, 'listWidget')
        listWidget.clear()    
        for item in feature.attribute('return_erfasser'):
            listWidget.addItem('text ' + item)


## Initialise form and controls        
def init():
    print('initialising form...')
    isInit = True
    
    
    #print(myFeature.attribute('return_erfasser'))
    global listWidget
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

def addStamp():
    
    form2 = QDialog()
    form2.show()
    
    fk_doc = lineEdit_id.text()
    fk_erf = lineEdit_user.text()
    query = con.exec('INSERT INTO development.ref_edithistory(fk_doc, fk_erf, "timestamp") VALUES (' + fk_doc + ', ' + fk_erf + ', NOW());')    
    print(query)
    query = None

###############################################################################
    