//
//  ParentViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterViewController.h"

@protocol ParentViewController <NSObject>

@required
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithMasterViewController:(MasterViewController *) mvc;

@property (retain, nonatomic) MasterViewController *MVC;

@end
