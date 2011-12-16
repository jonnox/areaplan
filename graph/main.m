#import "Vertex.h"
#import "Edge.h"
#import "Graph.h"

int main(void) {
   Graph *g = [[Graph alloc] init];

   Vertex *v0 = [[Vertex alloc] initWithID:0 X:0 Y:0 Z:0];
   Vertex *v1 = [[Vertex alloc] initWithID:1 X:0 Y:0 Z:0];
   Vertex *v2 = [[Vertex alloc] initWithID:2 X:0 Y:0 Z:0];
   Vertex *v3 = [[Vertex alloc] initWithID:3 X:0 Y:0 Z:0];
   Vertex *v4 = [[Vertex alloc] initWithID:4 X:0 Y:0 Z:0];
   Vertex *v5 = [[Vertex alloc] initWithID:5 X:0 Y:0 Z:0];
   Vertex *v6 = [[Vertex alloc] initWithID:6 X:0 Y:0 Z:0];

   Edge *e1 = [[Edge alloc] initWithID:0 SourceID:0 DestID:1 Weight:79.83];
   Edge *e2 = [[Edge alloc] initWithID:1 SourceID:0 DestID:5 Weight:81.15];

   Edge *e3 = [[Edge alloc] initWithID:2 SourceID:1 DestID:0 Weight:79.75];
   Edge *e4 = [[Edge alloc] initWithID:3 SourceID:1 DestID:2 Weight:39.42];
   Edge *e5 = [[Edge alloc] initWithID:4 SourceID:1 DestID:3 Weight:103];

   Edge *e6 = [[Edge alloc] initWithID:5 SourceID:2 DestID:1 Weight:38.65];

   Edge *e7 = [[Edge alloc] initWithID:6 SourceID:3 DestID:1 Weight:102.53];
   Edge *e8 = [[Edge alloc] initWithID:7 SourceID:3 DestID:5 Weight:61.44];
   Edge *e9 = [[Edge alloc] initWithID:8 SourceID:3 DestID:6 Weight:96.79];

   Edge *e10 = [[Edge alloc] initWithID:9 SourceID:4 DestID:5 Weight:133.04];

   Edge *e11 = [[Edge alloc] initWithID:10 SourceID:5 DestID:0 Weight:81.77];
   Edge *e12 = [[Edge alloc] initWithID:11 SourceID:5 DestID:3 Weight:62.05];
   Edge *e13 = [[Edge alloc] initWithID:12 SourceID:5 DestID:4 Weight:134.47];
   Edge *e14 = [[Edge alloc] initWithID:13 SourceID:5 DestID:6 Weight:91.63];

   Edge *e15 = [[Edge alloc] initWithID:14 SourceID:6 DestID:3 Weight:97.24];
   Edge *e16 = [[Edge alloc] initWithID:14 SourceID:6 DestID:5 Weight:87.94];

   [g.vertices addObject:v0];
   [g.vertices addObject:v1];
   [g.vertices addObject:v2];
   [g.vertices addObject:v3];
   [g.vertices addObject:v4];
   [g.vertices addObject:v5];
   [g.vertices addObject:v6];

   [g.edges addObject: e1];
   [g.edges addObject: e2];
   [g.edges addObject: e3];
   [g.edges addObject: e4];
   [g.edges addObject: e5];
   [g.edges addObject: e6];
   [g.edges addObject: e7];
   [g.edges addObject: e8];
   [g.edges addObject: e9];
   [g.edges addObject: e10];
   [g.edges addObject: e11];
   [g.edges addObject: e12];
   [g.edges addObject: e13];
   [g.edges addObject: e14];
   [g.edges addObject: e15];
   [g.edges addObject: e16];

   NSArray* path = [g dijkstraShortestPathFrom:0 To:6];

   NSLog(@"%@", path);

   [g dealloc];
   return 0;
}
