//
//  TaskWithCheckBoxTableViewCell.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/23/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxView.h"
#import "Tasks.h"
@interface TaskWithCheckBoxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CheckBoxView *checkBoxView;

@end
