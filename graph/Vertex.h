#import <Foundation/Foundation.h>

@interface Vertex : NSObject
{
   int id;
   int x;
   int y;
   int z;
}

@property int id, x, y, z;

- (id) initWithID: (int)newID X: (int)newX Y: (int)newY Z: (int)newZ;

@end
