//
//  NotificationPermissionHandler.m
//  Daily Tasks
//
//  Created by xiaoguang on 9/26/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import "NotificationPermissionHandler.h"

@implementation NotificationPermissionHandler

static const UIUserNotificationType USER_NOTIFICATION_TYPES_REQUIRED = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
static const UIRemoteNotificationType REMOTE_NOTIFICATION_TYPES_REQUIRED = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;

+ (void)checkPermissions;
{
    bool isIOS8OrGreater = [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)];
    if (!isIOS8OrGreater)
    {
        [NotificationPermissionHandler iOS7AndBelowPermissions];
        return;
    }
    
    [NotificationPermissionHandler iOS8AndAbovePermissions];
}

+ (void)iOS7AndBelowPermissions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:REMOTE_NOTIFICATION_TYPES_REQUIRED];
}

+ (void)iOS8AndAbovePermissions;
{
    if ([NotificationPermissionHandler canSendNotifications])
    {
        return;
    }
    
    UIUserNotificationSettings* requestedSettings = [UIUserNotificationSettings settingsForTypes:USER_NOTIFICATION_TYPES_REQUIRED categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:requestedSettings];
}

+ (bool)canSendNotifications;
{
    UIApplication *application = [UIApplication sharedApplication];
    bool isIOS8OrGreater = [application respondsToSelector:@selector(currentUserNotificationSettings)];
    
    if (!isIOS8OrGreater)
    {
        return true;
    }
    
    UIUserNotificationSettings* notificationSettings = [application currentUserNotificationSettings];
    bool canSendNotifications = notificationSettings.types == USER_NOTIFICATION_TYPES_REQUIRED;
    
    return canSendNotifications;
}


@end
