import sqlite3

conn = sqlite3.connect('areaplan.db');

curr = conn.cursor()

imageName = "maplogo2.png"                                            
imageFile = open(imageName, 'rb')                                 
b = sqlite3.Binary(imageFile.read())

curr.execute('insert into maps values (?,?,?)',(10000000,'UOIT - UA',b))

conn.commit()

curr.close()
