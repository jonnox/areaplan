#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "Edge.h"

@interface Graph : NSObject
{
   NSMutableArray *vertices;
   NSMutableArray *edges;
   int lastSource;
}

@property (retain, nonatomic) NSMutableArray *edges, *vertices;
@property int lastSource;

- (Vertex*) getVertexByID: (int)ID;
- (Vertex*) getVertexFromPriorityQueue;
- (void) computePathsFromSource: (int)sourceID;
- (NSArray*) getShortestPathToTarget: (int)targetID;
- (NSArray*) dijkstraShortestPathFrom: (int)sourceID To: (int)destID;


@end
