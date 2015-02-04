//
//  TaskWithCheckBoxTableViewCell.m
//  Daily Tasks
//
//  Created by xiaoguang on 9/23/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import "TaskWithCheckBoxTableViewCell.h"
#define SPACE_FOR_TEXTLABEL_TO_EDGE 15

@implementation TaskWithCheckBoxTableViewCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.opaque = NO;
    [self.textLabel sizeToFit];
    CGSize size = self.bounds.size;
    CGRect frame1 = CGRectMake(self.bounds.origin.x + 44.0f, self.bounds.origin.y, size.width, size.height);
        self.textLabel.frame = frame1;
    self.textLabel.contentMode = UIViewContentModeScaleAspectFit;
}

@end
