//
//  OBJViewController.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "OBJViewController.h"
#import "OBJTask.h"
#import "TaskData.h"
#import "OBJDetailTaskViewController.h"

@interface OBJViewController ()

@end

@implementation OBJViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
    
//    NSArray *tasks = [TaskData someTasks];
//    for (NSDictionary *dictionary in tasks) {
//        OBJTask *task = [[OBJTask alloc] initWithData:dictionary];
//        NSLog(@"%@",task.title);
//    }
    
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    //[self updateSectionTaskDictionaries];
    
//    [self.taskObjects removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
//    [[NSUserDefaults standardUserDefaults] synchronize];


//    [self.taskObjects removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TASKS_LIST];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//

    
//    NSLog(@"%i",[self.taskObjectsOverdue count]);
//    NSLog(@"%i",[self.taskObjectsNotDue count]);
//    NSLog(@"%i",[self.taskObjectsCompleted count]);
//    NSLog(@"%@",self.taskObjects);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender
{
    if (self.tableView.editing)
        [self.tableView setEditing:NO animated:YES];
    else
        [self.tableView setEditing:YES animated:YES];
}

- (IBAction)addtaskButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"viewControllerToAddTaskViewControllerSegue" sender:sender];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[OBJAddTaskViewController class]]) {
        OBJAddTaskViewController *addtaskVC = segue.destinationViewController;
        addtaskVC.delegate = self;
    }
    
    if([sender isKindOfClass:[NSIndexPath class]]){
        if ([segue.destinationViewController isKindOfClass:[OBJDetailTaskViewController class]]) {
            OBJDetailTaskViewController *detailVC = segue.destinationViewController;
            NSIndexPath *path = sender;
            if (path.section == 3)
                detailVC.taskObject = [self propertyListToTaskObject:self.taskObjectsOverdue[path.row]];
            else if (path.section == 1)
                detailVC.taskObject = [self propertyListToTaskObject:self.taskObjectsNotDue[path.row]];
            else if (path.section == 2)
                detailVC.taskObject = [self propertyListToTaskObject:self.taskObjectsCompleted[path.row]];
            else
                detailVC.taskObject = [self propertyListToTaskObject:self.taskObjects[path.row]];
            detailVC.path = path;
            detailVC.delegate = self;
        }
    }
}

#pragma mark - Setup TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    
    static NSString *cellIdentifier = @"TaskCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        OBJTask *taskObj = [self propertyListToTaskObject:self.taskObjects[indexPath.row]];
        cell.textLabel.text = taskObj.title;
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
        cell.detailTextLabel.text = [NSString stringWithFormat:@("%@"),[dateFormatter stringFromDate:taskObj.date]];
    
        [self updateCellColour:taskObj andCell:cell];
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return [self.taskObjects count];
    else if (section == 1) return [self.taskObjectsNotDue count];
    return [self.taskObjectsCompleted count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        OBJTask *task = [[OBJTask alloc] initWithData:self.taskObjects[indexPath.row]];
        
        task.completed = !task.completed;
        [self updateCellColour:task andCell:cell];
        
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        [self.taskObjects insertObject:[self taskObjectToPropertyList:task] atIndex:indexPath.row];
    }
    
    //[self updateTasksBySection];
        
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self updateSectionTaskDictionaries];
    [self.tableView reloadData];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self updateSectionTaskDictionaries];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.editing;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [self swapDataInArray:self.taskObjects atFirstIndex:sourceIndexPath.row atSecondIndex:destinationIndexPath.row];
    
        [self saveTasks:self.taskObjects];
        //[self updateSectionTaskDictionaries];
    }
    
    //[self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailsViewControllerSegue" sender:indexPath];
}

#pragma mark - Delegate Methods

-(void) didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didAddTask:(OBJTask *)task
{
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST]mutableCopy];
    [self.taskObjects addObject:[self taskObjectToPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self updateSectionTaskDictionaries];
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy Instantiations

-(NSMutableArray *)taskObjects
{
    if (!_taskObjects) _taskObjects = [[NSMutableArray alloc] init];
    
    return _taskObjects;

}

-(NSMutableArray *)taskObjectsCompleted
{
    if (!_taskObjectsCompleted) _taskObjectsCompleted = [[NSMutableArray alloc] init];
    
    return _taskObjectsCompleted;
    
}

-(NSMutableArray *)taskObjectsOverdue
{
    if (!_taskObjectsOverdue) _taskObjectsOverdue = [[NSMutableArray alloc] init];
    
    return _taskObjectsOverdue;
    
}

-(NSMutableArray *)taskObjectsNotDue
{
    if (!_taskObjectsNotDue) _taskObjectsNotDue = [[NSMutableArray alloc] init];
    
    return _taskObjectsNotDue;
    
}

#pragma mark - Helper Methods

-(NSDictionary *)taskObjectToPropertyList:(OBJTask *)task
{
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    dictionary[TITLE] = task.title;
    dictionary[DESCRIPTION] = task.description;
    dictionary[COMPLETION] = (task.completed)? @"YES":@"NO";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-dd-MM HH:mm"];
    
    dictionary[DATE] = [NSString stringWithFormat:@("%@"),[dateFormatter stringFromDate:task.date]];
    
    return dictionary;
}

-(OBJTask *)propertyListToTaskObject:(NSDictionary *)dictionary
{
    OBJTask *task = [[OBJTask alloc] initWithData:dictionary];
    return task;
}

-(BOOL)isDateGreaterThanDate:(NSDate *)date;
{
    NSDate *today = [NSDate date];
    int taskDate = [date timeIntervalSince1970];
    int todayDate = [today timeIntervalSince1970];
    
    return todayDate < taskDate;
}

-(void)updateCellColour:(OBJTask *)task andCell:(UITableViewCell *)cell
{
    if (task.completed) cell.backgroundColor = [UIColor greenColor];
    else if (!task.completed && ![self isDateGreaterThanDate:task.date]) cell.backgroundColor = [UIColor redColor];
    else if (!task.completed && [self isDateGreaterThanDate:task.date]) cell.backgroundColor = [UIColor yellowColor];
}

-(void)swapDataInArray:(NSMutableArray *)array atFirstIndex:(int)sourceIndex atSecondIndex:(int)destinationIndex
{
    NSDictionary *temp = array[sourceIndex];
    [array removeObjectAtIndex:sourceIndex];
    [array insertObject:temp  atIndex:destinationIndex];
}

-(void)saveTasks:(NSMutableArray *)tasksArray
{
    [[NSUserDefaults standardUserDefaults] setObject:tasksArray forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateSectionTaskDictionaries
{
    [self.taskObjectsOverdue removeAllObjects];
    [self.taskObjectsNotDue removeAllObjects];
    [self.taskObjectsCompleted removeAllObjects];
    
    for (NSDictionary *dictionary in self.taskObjects) {
        OBJTask *taskObject = [self propertyListToTaskObject:dictionary];
        if (taskObject.completed) [self.taskObjectsCompleted addObject:dictionary];
        else if (![self isDateGreaterThanDate:taskObject.date] && !taskObject.completed) [self.taskObjectsOverdue addObject:dictionary];
        else if ([self isDateGreaterThanDate:taskObject.date] && !taskObject.completed)[self.taskObjectsNotDue addObject:dictionary];
    }
}

-(void)updateTasksBySection
{
    [self.taskObjects removeAllObjects];
    
    for (NSDictionary *dictionary in self.taskObjectsCompleted) {
        [self.taskObjects addObject:dictionary];
    }
    for (NSDictionary *dictionary in self.taskObjectsOverdue) {
        [self.taskObjects addObject:dictionary];
    }
    for (NSDictionary *dictionary in self.taskObjectsNotDue) {
        [self.taskObjects addObject:dictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Edit Delegate methods

-(void)saveEdittedTask:(NSMutableArray *)edittedTasks andTask:(OBJTask *)taskObject atPath:(int)path
{
    NSDictionary *dictionary = [self taskObjectToPropertyList:taskObject];
    [edittedTasks removeObjectAtIndex:path];
    [edittedTasks insertObject:dictionary atIndex:path];
    //edittedTasks[path] = dictionary;
    
    [self saveTasks:edittedTasks];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:edittedTasks forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)refreshSectionTasks
{
    [self updateSectionTaskDictionaries];
}

@end
