//
//  NotificationPermissionHandler.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/26/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationPermissionHandler : NSObject

+ (void)checkPermissions;
+ (bool)canSendNotifications;

@end
