//
//  MasterViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

extern int const MAIN_VIEW_ID;

@interface MasterViewController : UIViewController{
    MainViewController *mainViewController;
}

@property (nonatomic, retain) MainViewController *mainViewController;

-(void)switchToViewByID:(int)viewID;

@end
