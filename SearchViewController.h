//
//  SearchViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface SearchViewController : UIViewController {
    UITableView *tableView;
    UISearchBar *searchBar;
    MapViewController *parentVC;

}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain,nonatomic) MapViewController *parentVC;

-(IBAction)cancel:(id)sender;

@end
