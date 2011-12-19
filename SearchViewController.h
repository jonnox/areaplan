//
//  SearchViewController.h
//  AreaPlan
//
//  Created by Jon on 11-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    UISearchBar *searchBar;
    MapViewController *parentVC;
    NSMutableArray *POI;
    NSMutableArray *displayList;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain,nonatomic) MapViewController *parentVC;
@property (retain,nonatomic) NSMutableArray *POI;
@property (retain,nonatomic) NSMutableArray *displayList;

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(IBAction)cancel:(id)sender;
- (void)getPOIData;
- (int) rankString1: (const char*) s1 String2: (const char*) s2;
-(void) print;

@end
