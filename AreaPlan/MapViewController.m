//
//  MapViewController.m
//  AreaPlan
//
//  Created by Jon on 11-12-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

#import "AppDelegate.h"

@implementation MapViewController

/**
 * MasterViewController to switch between global views
 */
@synthesize MVC;

-(IBAction)click:(id)sender{
    [self.MVC switchToViewByID:MAIN_VIEW_ID];
}

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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
