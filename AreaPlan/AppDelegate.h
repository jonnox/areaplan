//
//  AppDelegate.h
//  AreaPlan
//
//  Created by Jon on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    IBOutlet UIWindow *window;
	IBOutlet MasterViewController *masterViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MasterViewController *masterViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
