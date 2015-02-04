//
//  CheckBoxView.m
//  Daily Tasks
//
//  Created by xiaoguang on 9/23/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import "CheckBoxView.h"

@implementation CheckBoxView

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    [self setNeedsDisplay];
}



- (void)setIsCompletion:(BOOL)isCompletion
{
    _isCompletion = isCompletion;
    [self setNeedsDisplay];
}

- (void)setMiddleTask:(Tasks *)task
{
    _middleTask = task;
    if ([task.completionStatus isEqualToString:@"YES"]) {
        self.isCompletion = YES;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
        self.isCompletion = !self.isCompletion;
    if (self.isCompletion) {
        self.middleTask.completionStatus = @"YES";
    } else {
        self.middleTask.completionStatus = @"NO";
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (![context save:nil]) {
        NSLog(@"save error!");
    }
    
    [self pushCellChangeNotification];
}

- (void)pushCellChangeNotification
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.middleTask
                                                         forKey:@"CompletionStatusChangedNotification"];
    
    NSString * const CompletionStatusChangedNotification = @"CompletionStatusChangedNotification";
    [[NSNotificationCenter defaultCenter] postNotificationName:CompletionStatusChangedNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)drawRect:(CGRect)rect
{
    self.opaque = NO;
    self.backgroundColor = nil;
    CGFloat center = self.bounds.size.width * 0.25f;
    UIBezierPath *round = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.origin.x + center, self.bounds.origin.y + center, self.bounds.size.height * 0.5, self.bounds.size.width * 0.5)];
    round.lineWidth = 3.0;
    
    [self.mainColor setStroke];
    [round stroke];
    if (self.isCompletion) {
        [self.mainColor setFill];
        [round fill];
    }
    
                           
}

@end
