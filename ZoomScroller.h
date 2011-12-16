//
//  ZoomScroller.h
//  AreaPlan
//
//  Created by Jon on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomScroller : UIScrollView <UIScrollViewDelegate>{
    IBOutlet UIImageView *imageView;
}

@property (retain,nonatomic) UIImageView *imageView;

-(void)setImage: (UIImage *) image;
-(void)setImage: (UIImage *) image withZoomMax:(float) maxLimit andZoomMin:(float) minLimit atZoom:(float)zoom;


@end
