#import <Edge.h>

@implementation Edge

@synthesize id, sourceID, destID, weight;

- (id) initWithID: (int)newID SourceID: (int)newSource DestID: (int)newDest Weight: (double)newWeight
{
   self = [super init];
   if (self != nil) {
      self.id = newID;
      self.sourceID = newSource;
      self.destID = newDest;
      self.weight = newWeight;
   }
   return self;
}

@end
