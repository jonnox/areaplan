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

NSMutableArray *images;

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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int i;
    UIImage *image; 
    
    if(images == nil){
        images = [[NSMutableArray alloc] initWithCapacity:11]; 
        [images addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"restroom" ofType:@"png"]]];
        for(i=0;i<4;i++)
        [images addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_POI_2" ofType:@"png"]]];
        [images addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"restaurant" ofType:@"png"]]];
        for(i=0;i<4;i++)
            [images addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_POI_2" ofType:@"png"]]];
    }
    
    [self setAlpha:0.0];
    for(i = 0; i < [xCoords count]; i++)
    {
        int xPos = [[xCoords objectAtIndex:i] intValue];
        int yPos = [[yCoords objectAtIndex:i] intValue];
    
        int type = [[drawType objectAtIndex:i] intValue];

        
        int width,height,hw,hh;
        
        width = 25;
        height = 25;
        hw = 12;
        hh = 12;
        
        if(type >= [images count]){
            NSLog(@"Out of bounds %d (%d)", type,[images count]);
            image = [images objectAtIndex:0];
        }else{
            image = [images objectAtIndex:type];
        }
        
        [image drawInRect:CGRectMake(xPos - (width / 2), yPos - (height / 2), width, height)];

    }
    
    // Draw highlighted section
    if([[highlight objectAtIndex:0] floatValue] >= 0.0){
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}


@end
