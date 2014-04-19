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
    
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self updateSectionTaskDictionaries];
    

//    [self.taskObjects removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TASKS_LIST];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
            if (path.section == 0)
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
    [self updateSectionTaskDictionaries];
    
    static NSString *cellIdentifier = @"TaskCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        OBJTask *taskObj = [self propertyListToTaskObject:self.taskObjectsOverdue[indexPath.row]];
        cell.textLabel.text = taskObj.title;
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
        cell.detailTextLabel.text = [NSString stringWithFormat:@("%@"),[dateFormatter stringFromDate:taskObj.date]];
    
        [self updateCellColour:taskObj andCell:cell];
    }
    
    else if (indexPath.section == 1) {
        OBJTask *taskObj = [self propertyListToTaskObject:self.taskObjectsNotDue[indexPath.row]];
        cell.textLabel.text = taskObj.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@("%@"),[dateFormatter stringFromDate:taskObj.date]];
        
        [self updateCellColour:taskObj andCell:cell];
    }
    
    else if (indexPath.section == 2) {
        OBJTask *taskObj = [self propertyListToTaskObject:self.taskObjectsCompleted[indexPath.row]];
        cell.textLabel.text = taskObj.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@("%@"),[dateFormatter stringFromDate:taskObj.date]];
        
        [self updateCellColour:taskObj andCell:cell];
    }


    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Overdues";
    else if (section == 1) return @"To-dos";
    else return @"Completed";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return [self.taskObjectsOverdue count];
    else if (section == 1) return [self.taskObjectsNotDue count];
    return [self.taskObjectsCompleted count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        OBJTask *task = [[OBJTask alloc] initWithData:self.taskObjectsOverdue[indexPath.row]];
        
        task.completed = !task.completed;
        [self updateCellColour:task andCell:cell];
        
        [self.taskObjectsOverdue removeObjectAtIndex:indexPath.row];
        [self.taskObjectsOverdue insertObject:[self taskObjectToPropertyList:task] atIndex:indexPath.row];
    }
    
    else if (indexPath.section == 1) {
        OBJTask *task = [[OBJTask alloc] initWithData:self.taskObjectsNotDue[indexPath.row]];
        
        task.completed = !task.completed;
        [self updateCellColour:task andCell:cell];
        
        [self.taskObjectsNotDue removeObjectAtIndex:indexPath.row];
        [self.taskObjectsNotDue insertObject:[self taskObjectToPropertyList:task] atIndex:indexPath.row];
    }
    
    else if (indexPath.section == 2) {
        OBJTask *task = [[OBJTask alloc] initWithData:self.taskObjectsCompleted[indexPath.row]];
        
        task.completed = !task.completed;
        [self updateCellColour:task andCell:cell];
        
        [self.taskObjectsCompleted removeObjectAtIndex:indexPath.row];
        [self.taskObjectsCompleted insertObject:[self taskObjectToPropertyList:task] atIndex:indexPath.row];
    }

    
    [self updateTasksBySection];
        
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSectionTaskDictionaries];
    [self.tableView reloadData];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0)
            [self.taskObjectsOverdue removeObjectAtIndex:indexPath.row];
        else if (indexPath.section == 1)
            [self.taskObjectsNotDue removeObjectAtIndex:indexPath.row];
        else if (indexPath.section == 2)
            [self.taskObjectsCompleted removeObjectAtIndex:indexPath.row];
        
        [self updateTasksBySection];
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
        if (sourceIndexPath.section == 0)
            [self swapDataInArray:self.taskObjectsOverdue atFirstIndex:sourceIndexPath.row atSecondIndex:destinationIndexPath.row];
        else if (sourceIndexPath.section == 1)
            [self swapDataInArray:self.taskObjectsNotDue atFirstIndex:sourceIndexPath.row atSecondIndex:destinationIndexPath.row];
        else if (sourceIndexPath.section == 2)
            [self swapDataInArray:self.taskObjectsCompleted atFirstIndex:sourceIndexPath.row atSecondIndex:destinationIndexPath.row];
    
        //[self saveTasks:self.taskObjects];
        //[self updateSectionTaskDictionaries];
    }
    
    [self updateTasksBySection];
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
    [self updateSectionTaskDictionaries];
    
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

-(void)saveEdittedTask:(NSMutableArray *)edittedTasks andTask:(OBJTask *)taskObject atPath:(NSIndexPath *)path
{
    NSDictionary *dictionary = [self taskObjectToPropertyList:taskObject];
    
    if (path.section == 0) {
        [self.taskObjectsOverdue removeObjectAtIndex:path.row];
        [self.taskObjectsOverdue insertObject:dictionary atIndex:path.row];
    }
    else if (path.section == 1) {
        [self.taskObjectsNotDue removeObjectAtIndex:path.row];
        [self.taskObjectsNotDue insertObject:dictionary atIndex:path.row];
    }
    else if (path.section == 2) {
        [self.taskObjectsCompleted removeObjectAtIndex:path.row];
        [self.taskObjectsCompleted insertObject:dictionary atIndex:path.row];
    }
    
    [self updateTasksBySection];
    //[self saveTasks:edittedTasks];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.taskObjects forKey:TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)refreshSectionTasks
{
    [self updateSectionTaskDictionaries];
}

@end
