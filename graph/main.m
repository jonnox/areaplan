#import "Vertex.h"
#import "Edge.h"
#import "Graph.h"

int main(void) {
   Graph *g = [[Graph alloc] init];

   Vertex *v1 = [[Vertex alloc] initWithID:0 X:0 Y:0 Z:0];
   Vertex *v2 = [[Vertex alloc] initWithID:0 X:0 Y:0 Z:0];
   Edge *e1 = [[Edge alloc] initWithID:0 SourceID:0 DestID:1 Weight:3];
   [g.vertices addObject:v1];
   [g.vertices addObject:v2];
   [g.edges addObject: e1];

   NSLog(@"Edge length is %d", [[g.edges objectAtIndex:0] weight]);
   
   [g dealloc];
   NSLog(@"Run!");
   return 0;
}
