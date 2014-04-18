//
//  OBJViewController.h
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBJAddTaskViewController.h"
#import "OBJDetailTaskViewController.h"

@interface OBJViewController : UIViewController <OBJAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, OBJDetailTaskViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addtaskButtonPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSMutableArray *taskObjects;
@property (strong, nonatomic) NSMutableArray *taskObjectsOverdue;
@property (strong, nonatomic) NSMutableArray *taskObjectsNotDue;
@property (strong, nonatomic) NSMutableArray *taskObjectsCompleted;

@end
