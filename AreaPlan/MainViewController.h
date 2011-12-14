//
//  MainViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface MainViewController : UIViewController <ParentViewController>{
    MasterViewController *MVC;
}

-(IBAction)click:(id)sender;

@end
