//
//  DailyTasksTableViewController.m
//  Daily Tasks
//
//  Created by xiaoguang on 9/13/14.
//  Copyright (c) 2014 com.Xiaoguang. All rights reserved.
//

#import "DailyTasksTableViewController.h"
#import "TaskWithCheckBoxTableViewCell.h"

#define SPACE_FOR_TEXTLABEL_TO_EDGE 15

@interface DailyTasksTableViewController ()

@property (strong, nonatomic) UIColor *cusBackgourndColor;
@property (strong, nonatomic) UIColor *navigationBarColor;
@property (strong, nonatomic) NSArray *colorOptions;
@property (strong, nonatomic) NSString *dateOfTableView;

@end

@implementation DailyTasksTableViewController

- (NSString* )dateOfTableView
{
    if (!_dateOfTableView) {
        _dateOfTableView = [self getspecificTime:@"MMM dd" specificTime:[NSDate date]];
    }
    return _dateOfTableView;
}

#pragma mark Define Color
- (NSArray *)colorOptions
{
    CGColorRef colorRef1 = [[UIColor colorWithRed:0.42 green:0.84 blue:0.63 alpha:1] CGColor];
    CGColorRef colorRef2 = [[UIColor colorWithRed:0.35 green:0.71 blue:0.90 alpha:1] CGColor];
    CGColorRef colorRef3 = [[UIColor colorWithRed:0.48 green:0.62 blue:0.98 alpha:1] CGColor];
    CGColorRef colorRef4 = [[UIColor colorWithRed:0.38 green:0.35 blue:0.83 alpha:1] CGColor];
    CGColorRef colorRef5 = [[UIColor colorWithRed:0.76 green:0.55 blue:0.98 alpha:1] CGColor];
    
    UIColor *color1 = [[UIColor alloc] initWithCGColor:colorRef1];
    UIColor *color2 = [[UIColor alloc] initWithCGColor:colorRef2];
    UIColor *color3 = [[UIColor alloc] initWithCGColor:colorRef3];
    UIColor *color4 = [[UIColor alloc] initWithCGColor:colorRef4];
    UIColor *color5 = [[UIColor alloc] initWithCGColor:colorRef5];
    
    _colorOptions = [NSArray arrayWithObjects:color1, color2, color3, color4, color5, nil];
    return  _colorOptions;
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

#pragma mark Initialization

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //add stupid code to test github
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * const CompletionStatusChangedNotification = @"CompletionStatusChangedNotification";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTableView:)
                                                 name:CompletionStatusChangedNotification
                                               object:nil];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Tasks"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskDate = %@ || isDaily == %@ && taskDate != %@",
                              [self getspecificTime:@"MMM dd" specificTime:[NSDate date]],
                              @"YES",
                              [self getspecificTime:@"MMM dd" specificTime:[[NSDate date] dateByAddingTimeInterval:24*60*60]]];
    [request setPredicate:predicate];
    self.todayTaskList = [[moc executeFetchRequest:request error:nil]mutableCopy];
    
    [self setTaskTableStyle];
    [self countBadgeNumber];
    
}

- (void)setTaskTableStyle
{

    self.title = [self getspecificTime:@"MMM dd" specificTime:[NSDate date]];

    self.tableView.backgroundColor = self.cusBackgourndColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 44, 0, 0);

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.barTintColor = self.navigationBarColor;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.opaque = NO;


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)changeTableView:(NSNotification *)notification
{
    
    [self countBadgeNumber];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.todayTaskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Daily Task Cell";
    
    TaskWithCheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TaskWithCheckBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                    reuseIdentifier:CellIdentifier];
    }
    
    Tasks *task = [self.todayTaskList objectAtIndex:indexPath.row];
    [self setCustomCell:task withCell:cell];
    [cell.checkBoxView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell.checkBoxView
                                                                                    action:@selector(tap:)]];

    
    return cell;
}

- (void)setCustomCell:(Tasks *)task withCell:(TaskWithCheckBoxTableViewCell *)cell
{
    cell.backgroundColor = nil;
    cell.opaque = NO;
    cell.checkBoxView.opaque = NO;
    cell.checkBoxView.backgroundColor = nil;
    UIColor *mainColor = [self.colorOptions objectAtIndex:task.colorSequence.intValue];
    cell.checkBoxView.mainColor = mainColor;
    
    cell.textLabel.text = task.taskName;
    cell.textLabel.textColor = mainColor;
    
    cell.checkBoxView.middleTask = task;
    
    

}

//Edit
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         [context deleteObject:[self.todayTaskList objectAtIndex:indexPath.row]];
        [self.todayTaskList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self countBadgeNumber];
        
    }
    if (![context save:nil]) {
        NSLog(@"save error!");
    }
}

#pragma mark Get Time with Format
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

- (void)countBadgeNumber
{
    [NotificationPermissionHandler checkPermissions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    for (Tasks *task in self.todayTaskList) {
        NSLog(@"complete: %@", task.completionStatus);
        
        if ([task.completionStatus isEqualToString:@"NO"]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber++;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
