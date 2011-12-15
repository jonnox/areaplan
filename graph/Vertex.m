#import <Vertex.h>

@implementation Vertex

@synthesize id, x, y, z;

- (id) initWithID: (int)newID X: (int)newX Y: (int)newY Z: (int)newZ
{
   self = [super init];
   if (self != nil) {
      self.id = newID;
      self.x = newX;
      self.y = newY;
      self.z = newZ;
   }
   return self;
}

@end
