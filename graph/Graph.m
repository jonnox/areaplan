#import "Graph.h"

@implementation Graph

@synthesize edges, vertices;

- (id) init {
   self = [super init];
   if (self != nil) {
      edges = [[NSMutableArray alloc] init];
      vertices = [[NSMutableArray alloc] init];
   }
   return self;
}

@end
