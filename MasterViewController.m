//
//  MasterViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import <sqlite3.h>

int const MAIN_VIEW_ID = 0;
int const MAP_VIEW_ID = 1;

@implementation MasterViewController

@synthesize mainViewController,mapViewController;
@synthesize currentViewID;

/**
 * Returns the map that is currently loaded
 */
-(int)getCurrentMap{
    if(self.mapViewController == nil)
        return -1;
    
    return self.mapViewController.cm_ID;
}

-(void)switchToViewByID:(int)viewID{
    UIViewController *currViewCont;
    UIViewController *nextViewCont;
    
    int fromViewID = currentViewID;
    
    switch (viewID) {
        case MAIN_VIEW_ID:
            if(self.mainViewController == nil)
                self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil andWithMasterViewController:self];
            nextViewCont = self.mainViewController;
            currentViewID = MAIN_VIEW_ID;
            break;
            
        case MAP_VIEW_ID:
            if(self.mapViewController == nil)
                self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil andWithMasterViewController:self];
            
            nextViewCont = self.mapViewController;
            currentViewID = MAP_VIEW_ID;
            [self willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight duration: 0];
            break;
    }
    
    switch (fromViewID) {
        case MAIN_VIEW_ID:
            currViewCont = self.mainViewController;
            break;
        case MAP_VIEW_ID:
            currViewCont = self.mapViewController;
            break;
    }

	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
    if(fromViewID < currentViewID)
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    else
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    [nextViewCont viewWillAppear:YES];
    [currViewCont viewWillDisappear:YES];
    
    [self.view addSubview:nextViewCont.view];
    
    //self.view = nextViewCont.view;
    
    
    [currViewCont.view removeFromSuperview];
    [currViewCont viewDidDisappear:YES];
    [nextViewCont viewDidAppear:YES];
    [UIView commitAnimations];
     
}

/**
 * Create main view for loading
 */
- (void)viewDidLoad
{
    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil andWithMasterViewController:self];
	self.mainViewController = viewController;
    
	viewController=nil; // [viewController release];
    
    // Display Main View
    [self.view addSubview:mainViewController.view];
    
    
    self.currentViewID = MAIN_VIEW_ID;
    //[self viewDidAppear:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * Load given map and change to that map
 */
-(void)mapSelector:(int)mapID withName:(NSString *)mapName{
    BOOL changeOK = YES;
    if(self.mapViewController == nil)
        self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil andWithMasterViewController:self];

    // If it is a different map, load new map
    if(self.mapViewController.cm_ID != mapID)
        changeOK = [self.mapViewController loadNewMap:mapID withName:mapName];
    
    if(changeOK)
        [self switchToViewByID:MAP_VIEW_ID];
}
/**
 * Populate the list of installed maps with their ID's
 */
-(BOOL)getMapList:(NSMutableArray *)mapIDList withNames:(NSMutableArray *)mapNameList{
    
    // Both need to be initialized outside of this function call
    if(mapIDList == nil || mapNameList == nil)
        return NO;
    
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:@"areaplan" ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, "SELECT id,name from maps", -1, &sqlstmtptr, NULL);
        while(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            [mapIDList addObject:[NSNumber numberWithInt:sqlite3_column_int(sqlstmtptr, 0)]];
            [mapNameList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlstmtptr, 1)]];
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
        return NO;
    }
    
    sqlite3_finalize(sqlstmtptr);
    
    return YES;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(currentViewID == MAP_VIEW_ID)
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    else if(currentViewID == MAIN_VIEW_ID)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}

@end
