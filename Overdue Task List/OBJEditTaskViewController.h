//
//  OBJEditTaskViewController.h
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBJTask.h"

@protocol OBJEditTaskViewControllerDelegate <NSObject>

@required
-(void)didSaveTask:(OBJTask *)edittedTasks;

@end

@interface OBJEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) id <OBJEditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) OBJTask *taskObject;

@end
