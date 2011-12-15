//
//  ZoomScroller.m
//  AreaPlan
//
//  Created by Jon on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoomScroller.h"

@implementation ZoomScroller

@synthesize imageView;


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)setImage: (UIImage *) image{
    if(! self.imageView){
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self setDelegate:self];
        [self addSubview:self.imageView];
    }else{
        [self.imageView setImage:image];
    }
    self.contentSize=image.size;
    [self setZoomScale:1.0];
}

-(void)setImage: (UIImage *) image withZoomMax:(float) maxLimit andZoomMin:(float) minLimit{
    [self setImage: image];
    self.minimumZoomScale=minLimit;
    self.maximumZoomScale=maxLimit;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

@end