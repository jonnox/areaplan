//
//  MapViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "SearchViewController.h"

@class QuartzView;
@class ZoomScroller;

@interface MapViewController : UIViewController 
        <ParentViewController,UIActionSheetDelegate,UIScrollViewDelegate>{
            MasterViewController *MVC;
            SearchViewController *searchView;
            IBOutlet QuartzView *overlay;
            IBOutlet ZoomScroller *zoomScroller;
            IBOutlet UIImageView *rightButtonImage;
            IBOutlet UIImageView *leftButtonImage;
            UIImage *image;
            NSString *cm_name;
}

@property (retain,nonatomic) QuartzView *overlay;
@property (retain,nonatomic) ZoomScroller *zoomScroller;
@property (retain,nonatomic) NSString *cm_name;
@property (retain,nonatomic) SearchViewController *searchView;

@property int cm_ID;
@property int cm_level;
@property int cm_totallevels;
@property float cm_maxzoom;
@property float cm_minzoom;
@property int cm_location, cm_startx, cm_starty; // Last Vertex user was at

-(void) goToPoint:(int) poiid;

/**
 * Load a new map for the view to handle
 */
-(BOOL)loadNewMap:(int)mapID withName:(NSString *)mapName;

-(IBAction)click:(id)sender;

- (IBAction)rightButton:(id)sender;
- (IBAction)leftButton:(id)sender;

-(IBAction)leftButtonDrag:(id)sender;

- (IBAction)rightButtonInitialPress:(id)sender;
- (IBAction)leftButtonInitialPress:(id)sender;

- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;


- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
