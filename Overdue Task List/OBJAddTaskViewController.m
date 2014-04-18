//
//  OBJAddTaskViewController.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "OBJAddTaskViewController.h"

@interface OBJAddTaskViewController ()

@end

@implementation OBJAddTaskViewController

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
    
    self.detailsTextView.delegate = self;
    self.titleTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.delegate didCancel];
}

- (IBAction)addtaskButtonPressed:(UIButton *)sender
{
    [self.delegate didAddTask: [self createTask]];
}

#pragma mark - UITextViewDelegate method

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.detailsTextView resignFirstResponder];
        return NO;
    }
    else
        return YES;
}

#pragma mark - UITextFieldDelegate method

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - Helper Methods

-(OBJTask *)createTask
{
    //unnecessary to use dictionary here
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    dictionary[TITLE] = self.titleTextField.text;
    dictionary[DESCRIPTION] = self.detailsTextView.text;
    dictionary[COMPLETION] = @"NO";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-dd-MM HH:mm"];
    dictionary[DATE] = [formatter stringFromDate:self.datePicker.date];
    
    OBJTask *task = [[OBJTask alloc] initWithData:dictionary];
    return task;
}
@end
