//
//  OBJDetailTaskViewController.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "OBJDetailTaskViewController.h"
#import "OBJEditTaskViewController.h"

@interface OBJDetailTaskViewController ()

@end

@implementation OBJDetailTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleTextField.text = self.taskObject.title;
    self.detailsTextView.text = self.taskObject.description;
    self.datePicker.date = self.taskObject.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[OBJEditTaskViewController class]]) {
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            OBJEditTaskViewController *editTaskVC = segue.destinationViewController;
            editTaskVC.taskObject = self.taskObject;
            editTaskVC.delegate = self;
        }
    }
}


- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"DetailTaskViewToEditTaskViewSegue" sender:sender];
}


#pragma mark - Helper method

-(void)updateDetailsView:(OBJTask *)task
{
    self.titleTextField.text = self.taskObject.title;
    self.detailsTextView.text = self.taskObject.description;
    self.datePicker.date = self.taskObject.date;
}

#pragma mark - EditTask Delegate method

-(void)didSaveTask:(OBJTask *)edittedTask
{
    self.taskObject = edittedTask;
    [self updateDetailsView:self.taskObject];
    
    NSMutableArray *taskObjects = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKS_LIST] mutableCopy];
    
    
    [self.delegate saveEdittedTask:taskObjects andTask:edittedTask atPath:self.path];
    [self.delegate refreshSectionTasks];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
