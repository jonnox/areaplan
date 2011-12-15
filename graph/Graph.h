#import <Foundation/Foundation.h>

@interface Graph : NSObject
{
   NSMutableArray *vertices;
   NSMutableArray *edges;
}

@property (retain, nonatomic) NSMutableArray *edges, *vertices;

@end
