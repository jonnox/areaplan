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
        <ParentViewController,UIActionSheetDelegate>{
    MasterViewController *MVC;
    IBOutlet QuartzView *overlay;
    IBOutlet ZoomScroller *zoomScroller;
}

@property (retain,nonatomic) QuartzView *overlay;
@property (retain,nonatomic) ZoomScroller *zoomScroller;

@property (retain,nonatomic) NSString *mapprop_name;

-(IBAction)click:(id)sender;

- (IBAction)rightButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
