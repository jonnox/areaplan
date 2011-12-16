//
//  QuartzView.m
//  AreaPlan
//
//  Created by Jon on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuartzView.h"

@implementation QuartzView

@synthesize xCoords, yCoords, drawType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (id)init
{
        NSLog(@"other");
    return self;
}
/*


 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *c = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"left_button" ofType:@"png"]];
    CGImageRef cRef = CGImageRetain(c.CGImage);
    int width = [c size].width;
    int height = [c size].height;
    
    int i;
    
    for(i = 0; i < [xCoords count]; i++)
    {
        int xPos = [[xCoords objectAtIndex:i] intValue];
        int yPos = [[yCoords objectAtIndex:i] intValue];
    
        NSLog(@"%d, %d, %d, %d", xPos, yPos, width, height);
        CGContextDrawImage(context, CGRectMake(xPos, yPos, width, height), cRef);
    }
    // 1186.000000,734.000000
}


@end
