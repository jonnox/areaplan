#import "Edge.h"

@implementation Edge

@synthesize destID, weight;

- (id) initWithDestID: (int)newDest Weight: (double)newWeight
{
   self = [super init];
   if (self != nil) {
      self.destID = newDest;
      self.weight = newWeight;
   }
   return self;
}

@end
