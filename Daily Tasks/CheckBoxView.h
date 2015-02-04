//
//  CheckBoxView.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/23/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "NotificationPermissionHandler.h"


@interface CheckBoxView : UIView

@property (strong, nonatomic) UIColor *mainColor;
@property (nonatomic) BOOL isCompletion;
@property (strong, nonatomic) Tasks *middleTask;

extern NSString *CompletionStatusChangedNotification;

- (void)tap:(UITapGestureRecognizer *) gesture;
@end
