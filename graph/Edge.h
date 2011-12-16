#import <Foundation/Foundation.h>

@interface Edge : NSObject
{
   int id;
   int sourceID;
   int destID;
   double weight;
}

@property int id, sourceID, destID;
@property double weight;

- (id) initWithID: (int)newID SourceID: (int)newSource DestID: (int)newDest Weight: (double)newWeight;

@end
