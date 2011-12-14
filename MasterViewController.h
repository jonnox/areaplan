//
//  MasterViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class MapViewController;

extern int const MAIN_VIEW_ID;
extern int const MAP_VIEW_ID;

@interface MasterViewController : UIViewController{
    MainViewController *mainViewController;
    MapViewController *mapViewController;
    int currentViewID;
}

@property int currentViewID;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) MapViewController *mapViewController;

-(void)switchToViewByID:(int)viewID;

@end
