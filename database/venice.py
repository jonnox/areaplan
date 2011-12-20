import sqlite3

p = [

[(50,70),(352,70),(352,440),(50,440),
"Unit F" , "North West Corner" , "$319,900\n1 Bedroom, 1 bath (ensuite) corner unit\n(66.40 sq.m)"],
[(352,70),(532,70),(532,440),(352,440),
"Unit E" , "North Side" , "$284,900\nOpen concept batchelor\n(39.40 sq.m)"],
[(532,70),(710,70),(710,440),(532,440),
"Unit D" , "North Side" , "$285,900\nOpen concept batchelor\n(40.30 sq.m)"],
[(710,70),(890,70),(890,440),(710,440),
"Unit C" , "North Side" , "$285,900\nOpen concept batchelor\n(40.30 sq.m)"],
[(890,70),(1076,70),(1076,440),(890,440),
"Unit B" , "North Side" , "$287,900\nOpen concept batchelor\n(41.40 sq.m)"],
[(1076,80),(1520,80),(1520,624),(1076,624),
"Unit A" , "North East Corner" , "$364,900\n2 Bedroom, 2 bath (master with ensuite). Separate kitchen with attached maid room\n(102.6 sq.m)"],

[(110,506),(520,506),(520,1005),(110,1005),
"Unit G" , "South West Corner" , "$394,900\n3 Bedroom, 2 bath (master with ensuite). Separate kitchen with attached maid room\n(119.50 sq.m)"],
[(520,690),(708,690),(708,1060),(520,1060),
"Unit H" , "South Side" , "$287,900\nOpen concept batchelor\n(41.40 sq.m)"],
[(708,690),(888,690),(888,1060),(708,1060),
"Unit I" , "South Side" , "$285,900\nOpen concept batchelor\n(40.10 sq.m)"],
[(888,690),(1066,690),(1066,1060),(888,1060),
"Unit J" , "South Side" , "$285,900\nOpen concept batchelor\n(40.10 sq.m)"],
[(1066,690),(1246,690),(1246,1060),(1066,1060),
"Unit K" , "South Side" , "$284,900\nOpen concept batchelor\n(39.30 sq.m)"],
[(1246,690),(1542,690),(1246,1060),(1542,1060),
"Unit L" , "South East Corner" , "$319,900\n1 Bedroom, 1 bath (ensuite) corner unit\n(66.00 sq.m)"]
]

name = '10000001'
conn = sqlite3.connect('10000001.db');
curr = conn.cursor()

i = 0
for poi in p:
	curr.execute("""INSERT INTO POI VALUES (%d,%d,'%s','%s',%d,'%s',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d);"""
	%(
	i,4,poi[4],poi[5],1,poi[6],
	poi[0][0],poi[0][1],
	poi[1][0],poi[1][1],
	poi[2][0],poi[2][1],
	poi[3][0],poi[3][1],
	(poi[0][0] + poi[1][0]) / 2,(poi[0][1] + poi[2][1]) / 2,
	(poi[1][0] - poi[0][0]) * (poi[2][1] - poi[0][1])
	))

curr.execute("""insert into mapinfo values (1,800,422,1,0.2,1.5,0.4);""")

conn.commit()

curr.close()
