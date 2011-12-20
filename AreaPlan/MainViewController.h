//
//  MainViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface MainViewController : UIViewController <ParentViewController, UITableViewDelegate,UITableViewDataSource>{
    MasterViewController *MVC;
    UITableView *tableView;
    NSMutableArray *mapNames;
    NSMutableArray *mapIDs;
    NSMutableArray *mapIcons;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;

-(IBAction)click:(id)sender;
-(void)refreshMapList;

@end
