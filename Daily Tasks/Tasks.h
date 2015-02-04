//
//  Tasks.h
//  Daily Tasks
//
//  Created by xiaoguang on 9/23/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSString * completionStatus;
@property (nonatomic, retain) NSString * isDaily;
@property (nonatomic, retain) NSString * needRemind;
@property (nonatomic, retain) NSDate * remindTime;
@property (nonatomic, retain) NSString * taskDate;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * colorSequence;

@end
