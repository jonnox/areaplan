//
//  MainViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize MVC, tableView;

-(IBAction)click:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Area Plan"
                message:@"Created by:\nDaniel St. Jacques\nJon Elliott"
                delegate:nil
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
    [alert show];
    alert = nil;

}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                  TableView Methods
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    int myid = [[mapIDs objectAtIndex:row] intValue];
    NSString *mynm = [mapNames objectAtIndex:row];
    //NSLog(@"Calling %@ - %d",mynm,myid);
    [MVC mapSelector:myid withName:mynm];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(mapIDs == nil)
        [self refreshMapList];
    return [mapIDs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"MainCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell==nil)
    {
        //UIViewController *c = [[UIViewController alloc] init];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    
    cell.textLabel.text = [mapNames objectAtIndex:[indexPath row]];;
    
    return cell;

}

/**
 * Grab updated map list
 */
-(void)refreshMapList{
    if(mapIDs == nil)
        mapIDs = [[NSMutableArray alloc] init];
    if(mapNames == nil)
        mapNames = [[NSMutableArray alloc] init];
    
    [self.MVC getMapList:mapIDs withNames:mapNames];
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithMasterViewController:(MasterViewController *) mvc{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.MVC = mvc;
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self refreshMapList];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"default.png"]];
}

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
