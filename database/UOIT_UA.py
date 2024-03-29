from Tkinter import *
import sqlite3

# master = Tk()
# win = Canvas(master, width=1590, height=844)
# win.pack()

conn = sqlite3.connect('10000000.db');

curr = conn.cursor()

poi = [
(	
	"Quiznos",
	5,
	"UA 1002",1,
	"Hours of operation:\tM-F: 8am - 4pm",
	[(348,280),(502,280),(502,345),(348,345)],
	10010,
	[2,3]
),
(
	"Restroom",
	0,
	"UA WA",1,
	"M/F/H",
	[(615,605),(670,605),(670,695),(615,695)],
	9000,
	[19]
),
(
	"Lecture Hall E",
	3,
	"UA 1120",1,
	"-",
	[(390 , 380),(570 , 380),(570 , 520),(390 , 520)],
	25200,
	[1,5,6]
),
(
	"Lecture Hall D",
	3,
	"UA 1140",1,
	"-",
	[(390 , 520),(570 , 520),(570 , 660),(390 , 660)],
	25200,
	[0,7]
),
(
	"Lecture Hall B",
	3,
	"UA 1220",1,
	"-",
	[(694 , 380),(794 , 380),(794 , 520),(694 , 520)],
	14000,
	[15,16]
),
(
	"Lecture Hall C",
	3,
	"UA 1240",1,
	"-",
	[(694 , 520),(794 , 520),(794 , 660),(694 , 660)],
	14000,
	[16,18]
),
(
	"Lecture Hall A",
	3,
	"UA 1350",1,
	"-",
	[(838 , 444),(1044 , 444),(1044 , 620),(838 , 620)],
	38000,
	[23,30,31]
),
(
	"Study Hall",
	6,
	"UA 1001",1,
	"Open to all UOIT students. Wifi and printers available",
	[(800 , 280),(913 , 280),(913 , 345),(800 , 345)],
	9000,
	[20]
),
(
	"Study Hall",
	6,
	"UA 1030",1,
	"Open to all UOIT students. Wifi and printers available",
	[(975 , 280),(1090 , 280),(1090 , 345),(975 , 345)],
	8000,
	[27]
),
(
	"Restroom",
	0,
	"UA",1,
	"M/F/H",
	[(1130,380),(1230,380),(1230,440),(1130,440)],
	8500,
	[32]
),
(
	"Science Lab",
	7,
	"UA 1420",1,
	"-",
	[(1100,440),(1230,440),(1230,515),(1100,515)],
	1200,
	[38]
),
(
	"Science Lab",
	7,
	"UA 1440",1,
	"-",
	[(1100,515),(1230,515),(1230,578),(1100,578)],
	1200,
	[39]
),
(
	"Science Lab",
	7,
	"UA 1460",1,
	"-",
	[(1130,585),(1250,585),(1250,658),(1130,658)],
	1200,
	[41]
),
(
	"Science Lab",
	7,
	"UA 1540",1,
	"-",
	[(1250,560),(1328,560),(1328,658),(1250,658)],
	1200,
	[40]
),
(
	"Science Lab",
	7,
	"UA 1520",1,
	"-",
	[(1328,560),(1400,560),(1400,658),(1328,658)],
	1200,
	[42]
),
(
	"Marine Toxicology Lab",
	7,
	"UA 1620",1,
	"Large fish tank to study toxic effects on fish",
	[(1438,382),(1540,382),(1540,450),(1438,450)],
	1200,
	[47]
),
(
	"UG Computer Science Lab",
	7,
	"UA 1640",1,
	"Available Work Hours:\n\tM-F: 1pm - 3pm",
	[(1438,450),(1540,450),(1540,540),(1438,540)],
	1300,
	[44]
),
(
	"Physics Lab",
	7,
	"UA 1660",1,
	"-",
	[(1438,540),(1540,540),(1540,634),(1438,634)],
	1300,
	[43]
),
(	
	"Tim Horton''s",
	5,
	"UA EA",1,
	"Hours of operation:\tM-F: 8am - 4pm",
	[(1260,378),(1300,378),(1300,418),(1260,418)],
	8000,
	[37]
)
]


V = [
(374,490,1),
(371,460,1),
(367,362,1),
(465,364,1),
(578,350,1),
(583,387,1),
(583,514,1),
(583,539,1),
(583,594,1),
(574,294,1),
(640,298,1),
(673,300,1),
(703,322,1),
(676,361,1),
(632,377,1),
(694,389,1),
(680,517,1),
(680,598,1),
(680,632,1),
(680,673,1),
(800,363,1),
(806,459,1),
(812,508,1),
(834,515,1),
(946,363,1),
(946,330,1),
(946,293,1),
(1083,363,1),
(1030,393,1),
(1065,438,1),
(1078,474,1),
(1078,564,1),
(1197,363,1),
(1224,332,1),
(1211,304,1),
(1246,304,1),
(1247,369,1),
(1281,382,1),
(1246,491,1),
(1246,524,1),
(1246,549,1),
(1243,569,1),
(1332,549,1),
(1428,549,1),
(1428,530,1),
(1428,490,1),
(1428,419,1),
(1418,397,1),
(1428,305,1)
]

E = [
[1],
[0,2],
[1,3],
[2,4],
[3,5,14],
[4,6,14,16],
[5,7,13,16],
[6,8,16],
[7,17],
[10],
[9,11],
[10,12,13],
[11,13],
[6,11,12,14,15,16,20],
[4,5,13,15],
[14,13],
[5,6,7,13,17],
[8,16],
[17,19],
[18],
[13,21,24],
[20,22],
[21,23],
[22],
[20,25,27],
[24,26],
[25],
[24,28,29,32],
[27,29],
[27,28,30],
[29,31],
[30],
[27,36],
[34],
[33,35],
[34,36,37,47,48],
[32,35,37,38,48],
[35,36,47,48],
[36,39],
[38,40],
[39,41,42],
[40],
[40,43],
[42,44],
[43,45],
[44,46],
[45,47],
[35,37,46,48],
[35,36,37,47]
]


myid = 0
for pp in poi:
	cpx = (pp[5][1][0] + pp[5][0][0]) / 2
	cpy = (pp[5][2][1] + pp[5][0][1]) / 2
	curr.execute("insert into POI values (%d,%d,'%s','%s',%d,'%s',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d);" %(myid,pp[1],pp[0],pp[2],pp[3],pp[4],pp[5][0][0],pp[5][0][1],pp[5][1][0],pp[5][1][1],pp[5][2][0],pp[5][2][1],pp[5][3][0],pp[5][3][1],cpx,cpy,pp[6]))
	for pvtx in pp[7]:
		curr.execute("insert into POI_vertices values (%d,%d);" %(myid,pvtx))
	myid += 1
	
myid = 0
for v in V:
   curr.execute("insert into vertices values (%d, %d, %d, %d);" % (myid, v[0], v[1], v[2]))
   myid += 1


myid = 0
for e in E:
   for target in e:
      curr.execute("insert into edges values (%d, %d, %d);" % (myid, target, 0)) 
   myid += 1

curr.execute("""insert into mapinfo values (4,800,422,1,0.4,1.0,0.6);""")

conn.commit()

curr.close()

#ei = 0
#for e in E:
#	for p in e:
#		win.create_line(
#			V[ei][0],V[ei][1],
#			V[p][0],V[p][1],
#			fill="black")
#	ei = ei + 1
#win.configure(background='white')
#win.mainloop()


