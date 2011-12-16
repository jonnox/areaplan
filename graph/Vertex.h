#import <Foundation/Foundation.h>

@interface Vertex : NSObject
{
   int id;
   int x;
   int y;
   int z;
   int previousID;
   int minDistance;
   BOOL inQueue;
}

@property int id, x, y, z, previousID, minDistance;
@property BOOL inQueue;

- (id) initWithID: (int)newID X: (int)newX Y: (int)newY Z: (int)newZ;

@end
