#import <Vertex.h>

@implementation Vertex

@synthesize id, x, y, z, previousID, minDistance, inQueue, edges;

- (id) initWithID: (int)newID X: (int)newX Y: (int)newY Z: (int)newZ
{
   self = [super init];
   if (self != nil) {
      self.id = newID;
      self.x = newX;
      self.y = newY;
      self.z = newZ;
      self.previousID = -1;
      self.minDistance = 99999;
      self.inQueue = false;
      self.edges = [[NSMutableArray alloc] init];
   }
   return self;
}

- (void) addEdgeTo: (int)destID Weight: (double)weight
{
   Edge *e = [[Edge alloc] initWithDestID:destID Weight:weight];
   [self.edges addObject:e];
}

@end
