CREATE TABLE vertices (id INTEGER, x INTEGER, y INTEGER, z INTEGER);
CREATE TABLE edges (v_id INTEGER, target_id INTEGER, weight INTEGER);
CREATE TABLE POI (id INTEGER, type INTEGER, name TEXT, location TEXT, level INTEGER, info TEXT, p1x INTEGER, p1y INTEGER, p2x INTEGER, p2y INTEGER, p3x INTEGER, p3y INTEGER, p4x INTEGER, p4y INTEGER, centerX INTEGER, centerY INTEGER, area INTEGER);
CREATE TABLE POI_vertices (poi_id INTEGER, v_id INTEGER);
CREATE TABLE mapinfo (levels INTEGER, startx INTEGER, starty INTEGER, startlevel INTEGER, minzoom FLOAT, maxzoom FLOAT, startzoom FLOAT);
