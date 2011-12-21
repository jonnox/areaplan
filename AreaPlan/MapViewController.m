//
//  MapViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

#import "AppDelegate.h"
#import "ZoomScroller.h"
#import "QuartzView.h"
#import <sqlite3.h>

int const SEL_SEARCH = 0;
int const SEL_MAIN_MENU = 1;
int const SEL_SETTINGS = 2;

BOOL hasLoaded = NO;
BOOL isHighlighted = NO;

int currentID = -1;
int startID = -1;
int endID = -1;

float ptstohighlight[8] = {-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0};

@implementation MapViewController

//MasterViewController to switch between global views
@synthesize MVC,searchView;
// create getters and setters for the view components
@synthesize overlay,zoomScroller;

@synthesize cm_ID,cm_level,cm_totallevels,cm_maxzoom,cm_minzoom,cm_location,cm_name, cm_startx, cm_starty;


-(void) clearPoints
{
    [[overlay xCoords] removeAllObjects];
    [[overlay yCoords] removeAllObjects];
    [[overlay drawType] removeAllObjects];
}

-(void) addPointX:(int) x Y:(int) y Type:(int) type
{
    [[overlay xCoords] addObject:[NSNumber numberWithInt:x]];
    [[overlay yCoords] addObject:[NSNumber numberWithInt:y]];
    [[overlay drawType] addObject:[NSNumber numberWithInt:type]];
}

/**
 * Calculates all drawable items for the current view (taking into account zoom)
 * and passes the info to QuartzView for drawing.
 */
-(void) addDrawablePonts
{
    // Initialization code
    if(![overlay xCoords])
    {
        overlay.xCoords = [[NSMutableArray alloc] init];    
    }
    if(![overlay yCoords])
    {
        overlay.yCoords = [[NSMutableArray alloc] init];
    }
    if(![overlay drawType])
    {
        overlay.drawType = [[NSMutableArray alloc] init];
    }
    [self clearPoints];
    
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    NSString *statement = [[NSString alloc] initWithFormat:@"SELECT type,centerX,centerY,area FROM POI WHERE level=%d",cm_level];
    
    // for each map location get center point
    int x,y;
    
    CGPoint offset = zoomScroller.contentOffset;
    int screenMinX = offset.x / zoomScroller.zoomScale;
    int screenMinY = offset.y / zoomScroller.zoomScale;
    int screenMaxX = (offset.x  + zoomScroller.bounds.size.width) / zoomScroller.zoomScale;
    int screenMaxY = (offset.y + zoomScroller.bounds.size.height) / zoomScroller.zoomScale;
    
    CGPoint SMA = CGPointMake(offset.x / zoomScroller.zoomScale,offset.y / zoomScroller.zoomScale);
    CGPoint SMB = CGPointMake((offset.x  + zoomScroller.bounds.size.width) / zoomScroller.zoomScale,(offset.y + zoomScroller.bounds.size.height) / zoomScroller.zoomScale );
    
    CGPoint ep = CGPointMake(SMB.x - SMA.x, SMB.y - SMA.y);
    CGPoint linearInterp = CGPointMake(zoomScroller.bounds.size.width / ep.x, 
                                       zoomScroller.bounds.size.height / ep.y);
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        while(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            x = sqlite3_column_int(sqlstmtptr,1);
            y = sqlite3_column_int(sqlstmtptr,2);
            // if currently on screen
            if(x >= screenMinX && y >= screenMinY && x < screenMaxX && y < screenMaxY)
            {
                // There is sufficient space to draw
                if(sqlite3_column_double(sqlstmtptr, 3)*zoomScroller.zoomScale > 2500){
                    int ratioX = x - SMA.x;
                    int ratioY = y - SMA.y;
                    
                    int screenX = ratioX * linearInterp.x;
                    int screenY = ratioY * linearInterp.y;
                    
                    [self addPointX:screenX Y:screenY Type:sqlite3_column_int(sqlstmtptr,0)];
                }
            }
        }
        
        if(isHighlighted){
            float tmpfpt[8] = {
                (ptstohighlight[0] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                (ptstohighlight[1] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                (ptstohighlight[2] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                (ptstohighlight[3] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                (ptstohighlight[4] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                (ptstohighlight[5] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                (ptstohighlight[6] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                (ptstohighlight[7] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y
            };
            
            [self.overlay setPoints:tmpfpt];
            //free(tmpfpt);
        }
         
    }
    
    [self.overlay setNeedsDisplay];
}

//++++++++++++++++++++++++++++++++++++++++++++++
/**
 * Scroll view has been changed
 */
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self clearPoints];
    [self.overlay setNeedsDisplay];
}
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self addDrawablePonts];
    }
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addDrawablePonts];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self addDrawablePonts];
}
- (void) scrollViewDidZoom:(UIScrollView *)scrollView{
    [self addDrawablePonts];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addDrawablePonts];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.zoomScroller.imageView;
}
//++++++++++++++++++++++++++++++++++++++++++++++


/**
 * Called when the user click the main RIGHT button. Activates
 * an action sheet
 */
- (IBAction)rightButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:cm_name
            delegate:self
            cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:nil
            otherButtonTitles:@"Search",@"Main Menu",nil];
	[actionSheet showInView:[[self view] window]];
	actionSheet = nil;
    rightButtonImage.alpha = 0.5;
}

/**
 * Called when the user click the main LEFT button.
 */
- (IBAction)leftButton:(id)sender{
    leftButtonImage.alpha = 0.5;
}

/**
 * Actions to perform from RIGHT (settings) button press
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case SEL_SEARCH:
            if(searchView == nil){
                searchView = [[SearchViewController alloc] initWithNibName:@"SearchView" bundle:nil];
                searchView.parentVC = self;
                searchView.searchBar.showsCancelButton = YES;
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            
            [searchView viewWillAppear:YES];
            [self viewWillDisappear:YES];
            [self.view addSubview:searchView.view];
            [self viewDidDisappear:YES];
            [searchView viewDidAppear:YES];
            [UIView commitAnimations];
            break;
        
        case SEL_MAIN_MENU:
            [self.MVC switchToViewByID:MAIN_VIEW_ID];
            break;
        
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Add starting point
    if(buttonIndex == 1)
    {
        startID = [self getVertexIdFromPoiId:currentID];
        [graph computePathsFromSource:startID];
    }
    // Add destination
    else if(buttonIndex == 2)
    {
        endID = [self getVertexIdFromPoiId:currentID];
    }
    
    if(startID > -1 && endID > -1)
    {
        //NSLog(@"Drawing path from %d to %d", startID, endID);
        
        //NSArray *a = [graph getShortestPathToTarget:endID];
        NSArray *a = [graph dijkstraShortestPathFrom:startID To:endID];
        //NSLog(@"Shortest path: %@", a); 
    }
}

-(int)getVertexIdFromPoiId:(int) poiId
{
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    int v_id;
    
    NSString *stmt = [[NSString alloc] initWithFormat:@"SELECT v_id FROM poi_vertices WHERE poi_id=%d", poiId];
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [stmt UTF8String], -1, &sqlstmtptr, NULL);
        if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            v_id = sqlite3_column_int(sqlstmtptr, 0);
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    //NSLog(@"%d to %d", poiId, v_id);
    return v_id;
}

/**
 * Executed when a user taps on the map at a given point. Accounts
 * for pan and zoom of image.
 */
- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self.zoomScroller];
    CGPoint p_on_map = CGPointMake(p.x / zoomScroller.zoomScale,p.y / zoomScroller.zoomScale);
    
    isHighlighted = NO;
    [self.overlay clearHArray];
    [self.overlay setNeedsDisplay];
    
    int x0,x1,y0,y1,pts,i,poiid;
    BOOL isIn;
    pts = 4;
    
    //(y - y0) (x1 - x0) - (x - x0) (y1 - y0)
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    NSString *statement = [[NSString alloc] initWithFormat:@"SELECT p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,id FROM POI WHERE level=%d",cm_level];
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        while(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            isIn = YES;
            // Perform Point in Polygon test for each point
            x0 = sqlite3_column_int(sqlstmtptr, (6));
            y0 = sqlite3_column_int(sqlstmtptr, (7));
            for(i=0;i<pts;i++){
                x1 = sqlite3_column_int(sqlstmtptr, (i*2));
                y1 = sqlite3_column_int(sqlstmtptr, (i*2 + 1));
                if(((p_on_map.y - y0)*(x1 - x0) - (p_on_map.x - x0)*(y1 - y0)) < 0){
                    isIn = NO;
                    break;
                }
                x0 = x1;
                y0 = y1;
            }
            poiid = sqlite3_column_int(sqlstmtptr, 8);
            
            if(isIn){
                break;
            }
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    sqlite3_finalize(sqlstmtptr);
    
    if(isIn){
        statement = [[NSString alloc] initWithFormat:@"SELECT name,info,location FROM POI WHERE id=%d",poiid];sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        currentID = poiid;
        if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithFormat:@"%s",sqlite3_column_text(sqlstmtptr, 0)]
                        message:[[NSString alloc] initWithFormat:@"%s\n\n(%s)",sqlite3_column_text(sqlstmtptr, 1),sqlite3_column_text(sqlstmtptr, 2)]
                        delegate:self 
                        cancelButtonTitle:@"Back to map"
                                                  otherButtonTitles: nil];
                        //otherButtonTitles:@"Mark as starting location", @"Mark as destination", nil];
            [alert show];
            alert = nil;
        }
    }
    sqlite3_finalize(sqlstmtptr);
}

-(void) goToPoint:(int) poiid{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    [self viewWillAppear:YES];
    [searchView viewWillDisappear:YES];
    [searchView.view removeFromSuperview];
    [searchView viewDidDisappear:YES];
    [self viewDidAppear:YES];
    [UIView commitAnimations];
     
    
    //float = [sender locationInView:self.zoomScroller];
   // CGPoint p_on_map = CGPointMake(p.x / zoomScroller.zoomScale,p.y / zoomScroller.zoomScale);
    
    int x0,y0,xf,yf,level,i;
    float area,zArea;
    float newScale = zoomScroller.zoomScale;
    
    //(y - y0) (x1 - x0) - (x - x0) (y1 - y0)
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
    NSString *statement = [[NSString alloc] initWithFormat:@"SELECT centerX,centerY,area,level,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y FROM POI WHERE id=%d", poiid];
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            // Perform Point in Polygon test for each point
            x0 = sqlite3_column_int(sqlstmtptr, (0));
            y0 = sqlite3_column_int(sqlstmtptr, (1));
            area = sqlite3_column_double(sqlstmtptr, 2);
            level = sqlite3_column_int(sqlstmtptr, (3));
            
            if([self changeLevel:level]){

                
                zArea = area * self.zoomScroller.zoomScale;
                if((zArea > 15000.0)||(zArea < 5000.0)){
                    newScale = 15000.0 / area;
                    if(newScale < self.zoomScroller.minimumZoomScale)
                        newScale = self.zoomScroller.minimumZoomScale;
                    [self.zoomScroller setZoomScale:newScale animated:YES];
                }
                
                xf = (x0 - self.zoomScroller.frame.size.width / 2) * self.zoomScroller.zoomScale;
                yf = (y0 - self.zoomScroller.frame.size.height / 2) * self.zoomScroller.zoomScale;
                
                if(xf < 0)
                    xf = 0;
                if(yf < 0)
                    yf = 0;

            
                [self.zoomScroller setContentOffset:CGPointMake(xf, yf) animated:YES];
                
                
                for(i=0;i<8;i++){
                    ptstohighlight[i] = sqlite3_column_int(sqlstmtptr, (i + 4));
                }
                
                
                float tmpfpt[8] = {
                    (ptstohighlight[0] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                    (ptstohighlight[1] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                    (ptstohighlight[2] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                    (ptstohighlight[3] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                    (ptstohighlight[4] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                    (ptstohighlight[5] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y,
                    (ptstohighlight[6] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.x,
                    (ptstohighlight[7] * self.zoomScroller.zoomScale) - self.zoomScroller.contentOffset.y
                };
                
                [self.overlay setPoints:tmpfpt];
                //free(tmpfpt);
                isHighlighted = YES;
                
                
                [self.overlay setNeedsDisplay];
            }
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    sqlite3_finalize(sqlstmtptr);

}

-(BOOL)changeLevel:(int)level{
    return YES;
}

/**
 * Load a new map for the view to handle
 */
-(BOOL)loadNewMap:(int)mapID withName:(NSString *)mapName {
    self.cm_ID = mapID;
    self.cm_name = mapName;
    
    if(hasLoaded == YES){
        sqlite3 *dbptr;
        sqlite3_stmt *sqlstmtptr;
        
        NSString *pth = [[NSString alloc] initWithFormat:@"%d",self.cm_ID];
    
        if(sqlite3_open([[[NSBundle mainBundle] pathForResource:pth ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
            sqlite3_prepare(dbptr, "SELECT * from mapinfo", -1, &sqlstmtptr, NULL);
            if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
                // Get number of leves
                self.cm_totallevels = sqlite3_column_int(sqlstmtptr, 0);
                // Get starting level
                cm_level = sqlite3_column_int(sqlstmtptr,3);
            
                // Set initial offset
                cm_startx = sqlite3_column_int(sqlstmtptr,1);
                cm_starty = sqlite3_column_int(sqlstmtptr,2);
            
                image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%d_%d.png",cm_ID,cm_level]];
                [self.zoomScroller setImage:image withZoomMax:sqlite3_column_double(sqlstmtptr, 5) andZoomMin:sqlite3_column_double(sqlstmtptr, 4) atZoom:sqlite3_column_double(sqlstmtptr, 6)];
            
                [zoomScroller setContentOffset:CGPointMake(cm_startx, cm_starty)];


            }
        }else{
            NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
            return NO;
        }
    }
    
    return YES;
}


/**
 * Initializes controller with a link to the program's root view
 * controller. This enables this controller to ask to change the view
 */
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithMasterViewController:(MasterViewController *) mvc{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.MVC = mvc;
        cm_name = @"";
        int i;
        [self.overlay initArray];
        for (i=0; i<8; i++) {
            [self.overlay.highlight addObject:[[NSNumber alloc]initWithFloat:-1.0]];
        }
    }
    return self;
}

- (IBAction)rightButtonInitialPress:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(btn.state == UIControlStateHighlighted)
        rightButtonImage.alpha = 1.0;
    else
        rightButtonImage.alpha = 0.5;
}

- (IBAction)leftButtonInitialPress:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(btn.state == UIControlStateHighlighted)
        leftButtonImage.alpha = 1.0;
    else{
        leftButtonImage.alpha = 0.5;
    }
}

-(void)highlightPOI:(int)poiid{
    sqlite3 *dbptr;
    int i;
    sqlite3_stmt *sqlstmtptr;
    
    
    NSString *statement = [[NSString alloc] initWithFormat:@"SELECT  p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y FROM POI WHERE id=%d", poiid];
    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, [statement UTF8String], -1, &sqlstmtptr, NULL);
        if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            
            for(i=0;i<8;i++){
                ptstohighlight[i] = sqlite3_column_double(sqlstmtptr, i);
            }

            [self.overlay setPoints:ptstohighlight];
        }
    }
}
-(void)clearHighlight{
    [self.overlay clearHArray];
    isHighlighted = NO;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
*/

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
    
    hasLoaded = YES;
    
    sqlite3 *dbptr;
    sqlite3_stmt *sqlstmtptr;
        
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, "SELECT * from mapinfo", -1, &sqlstmtptr, NULL);
        if(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            // Get number of leves
            self.cm_totallevels = sqlite3_column_int(sqlstmtptr, 0);
            // Get starting level
            cm_level = sqlite3_column_int(sqlstmtptr,3);
            
            // Set initial offset
            cm_startx = sqlite3_column_int(sqlstmtptr,1);
            cm_starty = sqlite3_column_int(sqlstmtptr,2);
            
            image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%d_%d.png",cm_ID,cm_level]];
            
            
            [zoomScroller setContentOffset:CGPointMake(cm_startx, cm_starty)];
            
            
            [self.zoomScroller setImage:image withZoomMax:sqlite3_column_double(sqlstmtptr, 5) andZoomMin:sqlite3_column_double(sqlstmtptr, 4) atZoom:sqlite3_column_double(sqlstmtptr, 6)];
            
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
    
    // Cool reveal animation, complements of jonnox
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [self.overlay setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
    
    [self.zoomScroller setDelegate:self];
    
    [self.zoomScroller setZoomScale:sqlite3_column_double(sqlstmtptr, 6) animated:YES];

    // Graph setup
    graph = [[Graph alloc] init];    
    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%d",self.cm_ID] ofType:@"db"] UTF8String], &dbptr) == SQLITE_OK){
        sqlite3_prepare(dbptr, "SELECT * from vertices", -1, &sqlstmtptr, NULL);
        while(sqlite3_step(sqlstmtptr) == SQLITE_ROW){
            
            int v_id = sqlite3_column_int(sqlstmtptr, 0);
            int x = sqlite3_column_int(sqlstmtptr, 1);
            int y = sqlite3_column_int(sqlstmtptr, 2);
            int z = sqlite3_column_int(sqlstmtptr, 3);
            
            Vertex *vertex = [[Vertex alloc] initWithID:v_id X:x Y:y Z:z];
            
            sqlite3_stmt *edgestmt;
            NSString *stmt = [[NSString alloc] initWithFormat:@"SELECT target_id, weight FROM edges WHERE v_id=%d", v_id];
            sqlite3_prepare(dbptr, "", -1, &edgestmt, NULL);
            while(sqlite3_step(edgestmt) == SQLITE_ROW)
            {
                int target = sqlite3_column_int(edgestmt, 0);
                int weight = sqlite3_column_int(edgestmt, 1);
                
                [vertex addEdgeTo:target Weight:weight]; 
            }
            [graph.vertices addObject:vertex];
        }
    }else{
        NSLog(@"Error: %s",sqlite3_errmsg(dbptr));
    }
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
