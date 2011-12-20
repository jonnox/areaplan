import sqlite3

conn = sqlite3.connect('areaplan.db');

curr = conn.cursor()

imageName = "venice_map_logo.png"                                            
imageFile = open(imageName, 'rb')                                 
b = sqlite3.Binary(imageFile.read())

curr.execute('insert into maps values (?,?,?)',(10000001,'Venice Condos',b))

conn.commit()

curr.close()
