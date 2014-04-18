//
//  OBJEditTaskViewController.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "OBJEditTaskViewController.h"

@interface OBJEditTaskViewController ()

@end

@implementation OBJEditTaskViewController

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
    
    self.titleTextField.delegate = self;
    self.detailsTextView.delegate = self;
    
    self.titleTextField.text = self.taskObject.title;
    self.detailsTextView.text = self.taskObject.description;
    self.datePicker.date = self.taskObject.date;
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

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    self.taskObject.title = self.titleTextField.text;
    self.taskObject.description = self.detailsTextView.text;
    self.taskObject.date = self.datePicker.date;
    
    [self.delegate didSaveTask:self.taskObject];
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

@end
