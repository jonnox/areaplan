#import <Foundation/Foundation.h>

@interface Edge : NSObject
{
   int id;
   int sourceID;
   int destID;
   int weight;
}

@property int id, sourceID, destID, weight;

- (id) initWithID: (int)newID SourceID: (int)newSource DestID: (int)newDest Weight: (int)newWeight;

@end
