#import <Foundation/Foundation.h>

@interface Edge : NSObject
{
   int destID;
   double weight;
}

@property int destID;
@property double weight;

- (id) initWithDestID: (int)newDest Weight: (double)newWeight;

@end
