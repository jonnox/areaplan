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

int const SEL_SEARCH = 0;
int const SEL_MAIN_MENU = 1;
int const SEL_SETTINGS = 2;

@implementation MapViewController

//MasterViewController to switch between global views
@synthesize MVC;
// create getters and setters for the view components
@synthesize overlay,zoomScroller;

@synthesize mapprop_name;

-(IBAction)click:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:mapprop_name
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Search",@"Main Menu",@"Settings",nil];
	[actionSheet showInView:[[self view] window]];
	actionSheet = nil;

}


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
    
    // for each map location get center point
    int x = 532;
    int y = 572;    
    int z = 1;

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
    
    // if currently on screen
    // need to also check z coordinate against current level
    if(x >= screenMinX && y >= screenMinY && x < screenMaxX && y < screenMaxY)
    {
        int ratioX = x - SMA.x;
        int ratioY = y - SMA.y;
        
        int screenX = ratioX * linearInterp.x;
        int screenY = ratioY * linearInterp.y;
        
        [self addPointX:screenX Y:screenY Type:0];
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
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.zoomScroller.imageView;
}
//++++++++++++++++++++++++++++++++++++++++++++++


/**
 * Called when the user click the main RIGHT button. Activates
 * an action sheet
 */
- (IBAction)rightButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:mapprop_name
            delegate:self
            cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:nil
            otherButtonTitles:@"Search",@"Main Menu",@"Settings",nil];
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
    NSLog(@"Selected option: %d",buttonIndex);
    
    switch (buttonIndex) {
        case SEL_SEARCH:
            break;
        
        case SEL_MAIN_MENU:
            [self.MVC switchToViewByID:MAIN_VIEW_ID];
            break;
            
        default:
            break;
    }
}

/**
 * Executed when a user taps on the map at a given point. Accounts
 * for pan and zoom of image.
 */
- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self.zoomScroller];
    CGPoint offset = zoomScroller.contentOffset;
    //NSLog(@"Location: %f,%f",p.x,p.y);
    NSLog(@"Location (zoom): (%f,%f)",p.x / zoomScroller.zoomScale,p.y / zoomScroller.zoomScale);
    //NSLog(@"Offset: (%f,%f)",offset.x,offset.y);
    NSLog(@"Offset (zoom): (%f,%f)",offset.x / zoomScroller.zoomScale,offset.y / zoomScroller.zoomScale);
    NSLog(@"Bottom Right: (%f,%f)",(offset.x  + zoomScroller.bounds.size.width) / zoomScroller.zoomScale,(offset.y + zoomScroller.bounds.size.height) / zoomScroller.zoomScale );
    
}


/**
 * Initializes controller with a link to the program's root view
 * controller. This enables this controller to ask to change the view
 */
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithMasterViewController:(MasterViewController *) mvc{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.MVC = mvc;
        mapprop_name = @"UOIT - UA";
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
    else
        leftButtonImage.alpha = 0.5;
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
    // Do any additional setup after loading the view from its nib.

    image = [UIImage imageNamed:@"floorplan.jpg"];
    [self.zoomScroller setImage:image withZoomMax:3.0 andZoomMin:0.5];
    [self.zoomScroller setDelegate:self];
    
    // Cool reveal animation, complements of jonnox
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [self.overlay setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
    
    [self.zoomScroller setContentOffset:CGPointMake((image.size.width / 2) - self.zoomScroller.frame.size.width,(image.size.height / 2) - self.zoomScroller.frame.size.height) animated:NO];
    [self.zoomScroller setZoomScale:0.5 animated:NO];
    
    
    /*
    // Rotates the view.
    CGAffineTransform transform = CGAffineTransformMakeRotation(3.14159/2);
    self.view.transform = transform;
	
    // Repositions and resizes the view.
    CGRect contentRect = CGRectMake(-80, -80, 480, 320);
    self.view.bounds = contentRect;
     */
    
    // Testing core data
    AppDelegate *a = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    NSManagedObjectContext *context = [a managedObjectContext];
    NSManagedObject *POI;
    
    POI = [NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:context];
    [POI setValue:[NSNumber numberWithInt:10] forKey:@"x"];
    [POI setValue:[NSNumber numberWithInt:11] forKey:@"y"];
    [POI setValue:[NSNumber numberWithInt:12] forKey:@"z"];
    NSError *error;
    [context save:&error];
    
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"POI" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSManagedObject *matches = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if([objects count] > 0)
    {
        for(int i= 0; i < [objects count]; i++)
        {
            matches = [objects objectAtIndex:i];
            NSNumber *x = [matches valueForKey:@"x"];
            //NSLog(@"%@", x);
        }
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
