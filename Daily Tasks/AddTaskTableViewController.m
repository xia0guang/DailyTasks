//
//  AddTaskTableViewController.m
//  Daily Tasks
//
//  Created by xiaoguang on 9/13/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import "AddTaskTableViewController.h"

#define  sectionOfDatePickerCell 2
#define  rowOfDatePickerCell 2
#define  datePickerCellHeight 180

@interface AddTaskTableViewController () <UITextFieldDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UISwitch *isDaily;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todayOrTomorrow;
@property (weak, nonatomic) IBOutlet UISwitch *needReminder;


@property (weak, nonatomic) IBOutlet UILabel *reminderTimeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerOutlet;
@property (weak, nonatomic) IBOutlet UILabel *reminderDateLabel;


@property (nonatomic) BOOL datePickerIsShowing;
@property (strong, nonatomic) NSDate *remindTime;
@property (strong, nonatomic) UIColor *cusBackgourndColor;
@property (strong, nonatomic) UIColor *navigationBarColor;

@end

@implementation AddTaskTableViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (UIColor*)navigationBarColor
{
    CGColorRef aqua = [[UIColor colorWithRed:0.63 green:1.0 blue:0.81 alpha:1.0] CGColor];
    UIColor *color = [[UIColor alloc] initWithCGColor:aqua];
    return color;
}

- (UIColor*)cusBackgourndColor
{
    CGColorRef aqua = [[UIColor colorWithRed:0.96 green:0.95 blue:0.92 alpha:1.0] CGColor];
    UIColor *color = [[UIColor alloc] initWithCGColor:aqua];
    return color;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNewTaskTable];
}

- (void)setNewTaskTable
{
    self.tableView.backgroundColor = self.cusBackgourndColor;
    self.navigationController.navigationBar.barTintColor = self.navigationBarColor;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.opaque = NO;
    
    self.isDaily.onTintColor = self.navigationBarColor;
    self.todayOrTomorrow.tintColor = self.navigationBarColor;
    self.needReminder.onTintColor = self.navigationBarColor;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    [self.todayOrTomorrow setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.taskName.delegate = self;
    
    [self setReminderTimeLabelDisplay:[NSDate date]];
    
    self.datePickerOutlet.datePickerMode = UIDatePickerModeTime;
    self.reminderDateLabel.text = @"Today";
    self.reminderDateLabel.textColor = self.reminderTimeLabel.textColor;
}

- (void) setReminderTimeLabelDisplay:(NSDate *) date
{
    self.reminderTimeLabel.text = [self getspecificTime:@"h:mm a" specificTime:date];

    self.reminderTimeLabel.textColor = self.needReminder.on? self.view.tintColor : [UIColor grayColor];
}

- (IBAction)needReminderChanged:(id)sender {
    
    self.reminderTimeLabel.textColor = self.needReminder.on? self.view.tintColor : [UIColor grayColor];
    [self.tableView reloadData];
    self.reminderDateLabel.textColor = self.reminderTimeLabel.textColor;
    
}

- (IBAction)setTaskDate:(id)sender
{
    if (self.todayOrTomorrow.selectedSegmentIndex == 0) {
        self.reminderDateLabel.text = @"Today";
    } else {
        self.reminderDateLabel.text = @"Tomorrow";
    }
    self.reminderDateLabel.textColor = self.reminderTimeLabel.textColor;
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    [self setReminderTimeLabelDisplay:sender.date];
    if (self.todayOrTomorrow.selectedSegmentIndex == 0) {
        self.remindTime = sender.date;
    } else {
        self.remindTime = [sender.date dateByAddingTimeInterval:24*60*60];
    }
}


- (IBAction)saveNewTask:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Tasks *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks"
                                                          inManagedObjectContext:context];
    newTask.taskName = self.taskName.text;
    
    if (newTask.taskName) {
        NSDate *setDate = self.todayOrTomorrow.selectedSegmentIndex == 0? [NSDate date] : [[NSDate date] dateByAddingTimeInterval:24*60*60];
        newTask.taskDate = [self getspecificTime:@"MMM dd" specificTime:setDate];
        newTask.remindTime = setDate;
        newTask.isDaily = self.isDaily.isOn? @"YES" : @"NO";
        newTask.completionStatus = @"NO";
        newTask.needRemind = self.needReminder.on? @"YES" : @"NO";
        NSNumber *rand = [[NSNumber alloc] initWithInt:arc4random() % 5];
        newTask.colorSequence = rand;
        
        if (self.needReminder.on) {
            [NotificationPermissionHandler checkPermissions];
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = [NSString stringWithFormat:@"It is time to complete task: %@", newTask.taskName];
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.fireDate = self.remindTime;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        
        if (![context save:nil]) {
            NSLog(@"save error!");
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelNewTask:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && indexPath.row == 1){
        
        if (self.needReminder.on) {
            if (self.datePickerIsShowing){
                
                [self hideDatePickerCell];
                
            }else {
                
                [self showDatePickerCell];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.datePickerOutlet.hidden = NO;
    self.datePickerOutlet.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.datePickerOutlet.alpha = 1.0f;
        
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePickerOutlet.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePickerOutlet.hidden = YES;
                     }];
}

#pragma mark TableViewDelegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"this is cell at %d section - %d", indexPath.section,indexPath.row);
//    cell.textLabel.tintColor = [UIColor darkGrayColor];
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.section == sectionOfDatePickerCell && indexPath.row == rowOfDatePickerCell){
        
        height = self.datePickerIsShowing && self.needReminder.on ? datePickerCellHeight : 0.0f;
        
    }
    
    return height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // make "return key" hide keyboard
    return YES;
}

- (NSString *)getspecificTime: (NSString *) cusformat specificTime:(NSDate *) specificTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:cusformat];
    if (!specificTime) {
        return [dateFormatter stringFromDate:[NSDate date]];
    } else {
        return [dateFormatter stringFromDate:specificTime];
    }
}


@end
