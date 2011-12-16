#import <Foundation/Foundation.h>
#import "Edge.h"

@interface Vertex : NSObject
{
   int id;
   int x;
   int y;
   int z;
   int previousID;
   int minDistance;
   BOOL inQueue;
   NSMutableArray *edges;
}

@property int id, x, y, z, previousID, minDistance;
@property BOOL inQueue;
@property (retain, nonatomic) NSMutableArray *edges;

- (id) initWithID: (int)newID X: (int)newX Y: (int)newY Z: (int)newZ;

- (void) addEdgeTo: (int)destID Weight: (double)weight;
@end
