//
//  DailyTasksTableViewController.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/13/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "CheckBoxView.h"

@interface DailyTasksTableViewController : UITableViewController

extern NSString *CompletionStatusChangedNotification;
@property (strong, nonatomic) NSMutableArray *todayTaskList;
@property (strong, nonatomic) NSMutableArray *dailyTaskList;

@end
