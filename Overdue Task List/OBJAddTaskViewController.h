//
//  OBJAddTaskViewController.h
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBJTask.h"

@protocol OBJAddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(OBJTask *)task;

@end

@interface OBJAddTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)addtaskButtonPressed:(UIButton *)sender;

@property (weak, nonatomic)id <OBJAddTaskViewControllerDelegate> delegate;

@end
