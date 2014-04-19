//
//  OBJDetailTaskViewController.h
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBJEditTaskViewController.h"

@protocol OBJDetailTaskViewControllerDelegate <NSObject>

@required
-(void)saveEdittedTask:(NSMutableArray *)edittedTask andTask:(OBJTask *)taskObject atPath:(NSIndexPath *)path;
-(void)refreshSectionTasks;

@end

@interface OBJDetailTaskViewController : UIViewController <OBJEditTaskViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) OBJTask *taskObject;
@property (strong, nonatomic) NSIndexPath *path;

@property (weak,nonatomic) id <OBJDetailTaskViewControllerDelegate> delegate;

@end
