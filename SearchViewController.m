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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    NSNumber *rowIndex = [displayList objectAtIndex:[indexPath row]];
    NSString *name = [[POI objectAtIndex:[rowIndex intValue]] objectAtIndex:1];
    NSString *loc = [[POI objectAtIndex:[rowIndex intValue]] objectAtIndex:2];

    cell.textLabel.text = name;
    cell.detailTextLabel.text = loc;
    
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
    [self.parentVC goToPoint:[
            [[POI objectAtIndex:
                        [[displayList objectAtIndex:row]intValue]
            ] objectAtIndex:0] intValue]
     ];
}


-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Rank rows based on query
    const char* query = [[[NSString alloc] initWithFormat:@" %@",searchText] UTF8String];
    int i;
    BOOL isNull = NO;
    if(strlen(query) > 0){
        for(i = 0; i < [POI count]; i++)
        {
            const char* name = [[[NSString alloc] initWithFormat:@" %@",[[POI objectAtIndex:i] objectAtIndex:1] ] UTF8String];
            const char* location = [[[NSString alloc] initWithFormat:@" %@",[[POI objectAtIndex:i] objectAtIndex:2] ] UTF8String];
            
            double lcs1 = [self rankString1:query String2:name];
            double lcs2 = [self rankString1:query String2:location];
            
            if(strlen(name) < strlen(query))
                lcs1 = lcs1 / strlen(name);
            else
                lcs1 = lcs1 / strlen(query);
            if(strlen(location) < strlen(query))
                lcs2 = lcs2 / strlen(location);
            else
                lcs2 = lcs2 / strlen(query);  
            
            if(lcs2 > lcs1)
                lcs1 = lcs2;
            
            [[POI objectAtIndex:i] setObject:[[NSNumber alloc] initWithDouble:lcs1] atIndex:3];
        }
        
        // Sort by ranks
        POI = [POI sortedArrayUsingComparator:^(id a, id b)
               {
                   NSNumber *one = [(NSArray*)a objectAtIndex:3];
                   NSNumber *two = [(NSArray*)b objectAtIndex:3];
                   
                   return [two compare:one];
               }];
        
    }else{
        isNull = YES;
    }
    // Update display list for table view
    [displayList removeAllObjects];
    
    if(isNull == NO){
        for(i = 0; i < [POI count]; i++)
        {
            
            double rank = [[[POI objectAtIndex:i] objectAtIndex:3] doubleValue];
            if(rank > 0.4)
                [displayList addObject:[[NSNumber alloc] initWithInt:i]];
            NSLog(@"%@ - %f",
                  [[POI objectAtIndex:i] objectAtIndex:1],rank);
        }
    }else{
        for(i = 0; i < [POI count]; i++)
        {
            [displayList addObject:[[NSNumber alloc] initWithInt:i]];
        }
    }
    [tableView reloadData];
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
        int i = 0;
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
            [displayList addObject:[[NSNumber alloc] initWithInt:i]];
            i++;
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    sqlite3_finalize(sqlstmtptr);
    
}

- (int) rankString1: (const char*) s1 String2: (const char*) s2
{
    if(strlen(s1) == 0 || strlen(s2) == 0)
        return 1;
    
    const int m = strlen(s1);
    const int n = strlen(s2);
    int d[m][n];
    int i, j;
    for(i=0; i<m; i++)
        d[i][0] = 0;
    for(j=0; j<n; j++)
        d[0][j] = 0;
    
    for(i=1; i<m; i++)
    {
        for(j=1; j<n; j++)
        {
            if(s1[i] == s2[j])
            {
                d[i][j] = d[i-1][j-1] + 1;
            }
            else
            {
                int max = d[i][j-1];
                int d2 = d[i-1][j];
                
                if(d2 > max)
                    max = d2;
                
                d[i][j] = max;
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
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.displayList = [[NSMutableArray alloc] init];
    [self getPOIData];
    [self.searchBar setDelegate:self];
    

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
