//
//  MapViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@class QuartzView;
@class ZoomScroller;

@interface MapViewController : UIViewController 
        <ParentViewController,UIActionSheetDelegate,UIScrollViewDelegate>{
            MasterViewController *MVC;
            IBOutlet QuartzView *overlay;
            IBOutlet ZoomScroller *zoomScroller;
            IBOutlet UIImageView *rightButtonImage;
            IBOutlet UIImageView *leftButtonImage;
            UIImage *image;
}

@property (retain,nonatomic) QuartzView *overlay;
@property (retain,nonatomic) ZoomScroller *zoomScroller;

@property (retain,nonatomic) NSString *mapprop_name;

-(IBAction)click:(id)sender;

- (IBAction)rightButton:(id)sender;
- (IBAction)leftButton:(id)sender;

- (IBAction)rightButtonInitialPress:(id)sender;
- (IBAction)leftButtonInitialPress:(id)sender;

- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
