//
//  SearchViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "MapViewController.h"
#import <sqlite3.h>

@implementation SearchViewController

@synthesize tableView,searchBar,parentVC, POI, displayList;

/**
 * Return to Map without selection
 */
-(IBAction)cancel:(id)sender{
    
    //[self.view removeFromSuperview];

    [parentVC goToPoint:-1];
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

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if([self.searchBar isFirstResponder] && [touch view] == self.tableView){
        [self.searchBar resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
 */

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell==nil)
    {
        //UIViewController *c = [[UIViewController alloc] init];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    NSInteger rowIndex = (NSInteger)[displayList objectAtIndex:[indexPath row]];
    NSString *name = [[POI objectAtIndex:rowIndex] objectAtIndex:1];
    NSString *loc = [[POI objectAtIndex:rowIndex] objectAtIndex:2];

    cell.textLabel.text = name;
    cell.detailTextLabel.text = loc;
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [displayList count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    [self.parentVC goToPOI:[POI objectAtIndex:(int)[displayList objectAtIndex:row]]];
}


-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Rank rows based on query
    const char* query = [searchText UTF8String];
    
    int i;
    for(i = 0; i < [POI count]; i++)
    {
        const char* name = [[[POI objectAtIndex:i] objectAtIndex:1] UTF8String];
        const char* location = [[[POI objectAtIndex:i] objectAtIndex:2] UTF8String];
        
        double d = (double)strlen(name) / [self rankString1:query String2:name];
        double d2 = (double)strlen(location) / [self rankString1:query String2:location];
        
        if(d2 < d)
            d = d2;
        
        [[POI objectAtIndex:i] setObject:[[NSNumber alloc] initWithInt:d] atIndex:3];
    }
    
    // Sort by ranks
    POI = [POI sortedArrayUsingComparator:^(id a, id b)
           {
               NSNumber *one = [(NSArray*)a objectAtIndex:3];
               NSNumber *two = [(NSArray*)b objectAtIndex:3];
               
               return [one compare:two];
           }];
    
    // Update table view
    [self print];
    
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)s{
    [s resignFirstResponder];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)s{
    [s resignFirstResponder];
}

#pragma mark - View lifecycle

- (void)getPOIData
{
    POI = [[NSMutableArray alloc] init];
    
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    NSString *statement = [[NSString alloc] initWithFormat:@"SELECT id, name, location FROM POI WHERE level=%d", parentVC.cm_level];
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",parentVC.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        while(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            NSNumber *id = [[NSNumber alloc] initWithInt:sqlite3_column_int(sqlstmtptr, 0)];
            NSString *name = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(sqlstmtptr, 1)];
            NSString *location = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(sqlstmtptr, 2)];
            
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:3];
            [row addObject:id];
            [row addObject:name];
            [row addObject:location];
            [row addObject:[[NSNumber alloc] initWithDouble:0.0]];
            [POI addObject:row];
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    sqlite3_finalize(sqlstmtptr);
    
}

- (int) rankString1: (const char*) s1 String2: (const char*) s2
{
    const int m = strlen(s1);
    const int n = strlen(s2);
    int d[m][n];
    int i, j;
    for(i=0; i<m; i++)
        d[i][0] = i;
    for(j=0; j<n; j++)
        d[0][j] = j;
    
    for(j=1; j<n; j++)
    {
        for(i=1; i<m; i++)
        {
            if(s1[i] == s2[j])
            {
                d[i][j] = d[i-1][j-1];
            }
            else
            {
                int min = INT_MAX;
                
                int deletion   = d[i-1][j] + 1;
                int insertion  = d[i][j-1] + 1;
                int substitute = d[i-1][j-1] + 1;
                if(deletion < min)
                    min = deletion;
                if(insertion < min)
                    min = insertion;
                if(substitute < min)
                    min = substitute;
                
                d[i][j] = min;
            }
        }
    }
    
    return d[m-1][n-1];
}

-(void) print
{
    int i;
    for(i = 0; i < [POI count]; i++)
    {
        NSLog(@"%@ - %@", [[POI objectAtIndex:i] objectAtIndex:1], [[POI objectAtIndex:i] objectAtIndex:2]);
    }
    NSLog(@"-----------------");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    [self.tableView setDelegate:self];
    [self getPOIData];


    // Do any additional setup after loading the view from its nib.
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
