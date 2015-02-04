//
//  AddTaskTableViewController.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/13/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "NotificationPermissionHandler.h"

@interface AddTaskTableViewController : UITableViewController
@property (strong, nonatomic) Tasks *tasks;
@end
