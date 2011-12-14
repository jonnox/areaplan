//
//  MasterViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "MainViewController.h"

int const MAIN_VIEW_ID = 0;

@implementation MasterViewController

@synthesize mainViewController;

-(void)switchToViewByID:(int)viewID{
    NSLog(@"Switch for screen %d requested",viewID);
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
    //self.view=nil;
    self.view = mainViewController.view;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
