//
//  QuartzView.m
//  AreaPlan
//
//  Created by Jon on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuartzView.h"

@implementation QuartzView

@synthesize xCoords, yCoords, drawType,highlight,isHighlighted;

enum DrawTypes{ RESTROOM=0, STORE=1, OFFICE=2, CLASSROOM=3, SUITE=4, RESTAURANT=5, PUBLIC_AREA=6, LAB=7, TELEPHONE=8, COMPUTER_INTERNET=9, STAIRS=10, ELEVATOR=11 };

NSMutableArray *images;

float hpts[8] = {-1,-1,-1,-1,-1,-1,-1,-1};

-(void) initArray{
    self.highlight = [NSMutableArray alloc];
}
-(void) setPoints:(float [])pts{
    int i;
    for(i=0;i<8;i++){
        hpts[i] = pts[i];
    }
    /*NSLog(@"Adding points:\n\n(%.2f,%.2f) (%.2f,%.2f)\n(%.2f,%.2f) (%.2f,%.2f)\n(%.2f,%.2f) (%.2f,%.2f)\n(%.2f,%.2f) (%.2f,%.2f)",
          hpts[0],hpts[1],pts[0],pts[1],
          hpts[2],hpts[3],pts[2],pts[3],
          hpts[4],hpts[5],pts[4],pts[5],
          hpts[6],hpts[7],pts[6],pts[7]);
     */
    isHighlighted = YES;
}
-(void) clearHArray{
    isHighlighted = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (id)init
{
    self = [super init];
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
    
    if(isHighlighted){
        // set line width 
        
        // Drawing code. 
        
        // get the drawing canvas (CGContext): 
        
        CGContextRef context = UIGraphicsGetCurrentContext(); 
        
        // save the context’s previous state: 
        
        CGContextSaveGState(context); 
        
        // our custom drawing code will go here: 
        
        
        
        CGContextSetLineWidth(context, 5); 
        
        // set the colour when drawing lines R,G,B,A 
        
        CGContextSetRGBStrokeColor(context, 0,0.5,0.8,0.5);
        
        CGContextMoveToPoint(context, hpts[0],hpts[1]);

        for(i=2; i < 8; i = i + 2){
            CGContextAddLineToPoint(context, hpts[i], hpts[i+1]);
        }
        CGContextAddLineToPoint(context, hpts[0], hpts[1]);
        
        CGContextStrokePath(context);
        
        // restore the context’s state when we are done with it: 
        
        CGContextRestoreGState(context); 
    }
     
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}


@end
