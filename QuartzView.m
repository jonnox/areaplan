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

enum DrawTypes{ RESTROOM=0, STORE=1, OFFICE=2, CLASSROOM=3, SUITE=4, RESTAURANT=5, PUBLIC_AREA=6, LAB=7, TELEPHONE=8, COMPUTER_INTERNET=9, STAIRS=10, ELEVATOR=11 };

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
    int i;
    UIImage *image; 
    
    for(i = 0; i < [xCoords count]; i++)
    {
        int xPos = [[xCoords objectAtIndex:i] intValue];
        int yPos = [[yCoords objectAtIndex:i] intValue];
    
        int type = [[drawType objectAtIndex:i] intValue];
        NSString *imageFilename;
        
        switch(type)
        {
            case RESTROOM:
                imageFilename = [[NSString alloc] initWithFormat:@"restroom"];
                break;
            case STORE:
                
                break;
            case OFFICE:
                
                break;
            case CLASSROOM:
                
                break;
            case SUITE:
                
                break;
            case RESTAURANT:
                imageFilename = [[NSString alloc] initWithFormat:@"restaurant"];
                break;
            case PUBLIC_AREA:
                
                break;
            case LAB:
                
                break;
            case TELEPHONE:
                
                break;
            case COMPUTER_INTERNET:
                
                break;
            case STAIRS:
                
                break;
            case ELEVATOR:
                
                break;
            default:
                imageFilename = [[NSString alloc] initWithFormat:@"left_button"];
        }
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
        
        //NSLog(@"%@", imageFilename);
        int width = [image size].width;
        int height = [image size].height;
        [image drawInRect:CGRectMake(xPos, yPos, width, height)];

    }
}


@end
