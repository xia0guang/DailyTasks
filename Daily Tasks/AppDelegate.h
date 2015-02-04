//
//  AppDelegate.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/13/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationPermissionHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
