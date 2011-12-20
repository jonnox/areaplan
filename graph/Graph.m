#import "Graph.h"

@implementation Graph

@synthesize edges, vertices, lastSource;

- (id) init {
   self = [super init];
   if (self != nil) {
      edges = [[NSMutableArray alloc] init];
      vertices = [[NSMutableArray alloc] init];
      lastSource = -1;
   }
   return self;
}

- (Vertex*) getVertexByID: (int)ID
{
   int i;
   for(i = 0; i < [vertices count]; i++)
   {
      if( [[vertices objectAtIndex:i] id] == ID)
      {
         return [vertices objectAtIndex:i];
      }
   }
   return nil;
}

- (Vertex*) getVertexFromPriorityQueue
{
   int lowest = 99999;
   int i, index = -1;
   for(i = 0; i < [vertices count]; i++)
   {
      Vertex* v = [vertices objectAtIndex:i];
      if([v inQueue] == YES)
      {
         if([v minDistance] < lowest)
         {
            index = i;
            lowest = [[vertices objectAtIndex:i] minDistance];
         }
      }
   }

   if(index >= 0)
   {
      [[vertices objectAtIndex:index] setInQueue:NO];
      return [vertices objectAtIndex:index];
   }

   return nil;
}

- (BOOL) queueIsEmpty
{
   int i;
   for(i = 0; i < [vertices count]; i++)
   {
      Vertex* v = [vertices objectAtIndex:i];
      if([v inQueue] == YES)
      {
         return NO;
      }
   }
   return YES;
}

- (void) computePathsFromSource: (int)sourceID
{
   int i;
   for(i = 0; i < [vertices count]; i++)
   {
      [[vertices objectAtIndex:i] setPreviousID:-1];
      [[vertices objectAtIndex:i] setMinDistance:99999];
   }

   Vertex *source = [self getVertexByID:sourceID];
   [source setMinDistance:0];
   [source setInQueue:YES];

   while([self queueIsEmpty] == NO)
   {
      Vertex *u = [self getVertexFromPriorityQueue];
      NSArray *uEdges = [u edges];
      
      int i;
      for(i = 0; i < [uEdges count]; i++)
      {
         Edge *e = [uEdges objectAtIndex:i];
         Vertex *v = [self getVertexByID:[e destID]];
         double weight = [e weight];
         double distanceThroughU = [u minDistance] + weight;
         if(distanceThroughU < [v minDistance])
         {
            [v setInQueue:NO];

            [v setMinDistance:distanceThroughU];
            [v setPreviousID:[u id]];
            [v setInQueue:YES];
         }
      }
   }
}

- (NSArray*) dijkstraShortestPathFrom: (int)sourceID To: (int)destID
{
   if(lastSource < 0 || lastSource != sourceID)
   {
      [self computePathsFromSource: sourceID];
      lastSource = sourceID;
   }

   return [self getShortestPathToTarget: destID];
}

- (NSArray*) getShortestPathToTarget: (int)targetID
{
   NSMutableArray *path = [[NSMutableArray alloc] init];
   
   Vertex *v = [self getVertexByID:targetID];
   do
   {
      [path addObject:[NSNumber numberWithInt:[v id]]];
      v = [self getVertexByID:[v previousID]];
   } while([v previousID] > -1);

   [path addObject:[NSNumber numberWithInt:[v id]]];

   NSArray* realPath = [[path reverseObjectEnumerator]    allObjects];

   return realPath;
}

@end
