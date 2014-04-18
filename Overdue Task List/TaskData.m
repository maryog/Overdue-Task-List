//
//  TaskData.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "TaskData.h"

@implementation TaskData

+ (NSArray *)someTasks
{
    NSMutableArray *taskData = [@[] mutableCopy];
    
    NSDictionary *firstTask = @{TITLE:@"morning", DESCRIPTION:@"Kill the alarm", DATE:@"2014-12-03", COMPLETION:@"YES"};
    [taskData addObject:firstTask];
    
    NSDictionary *secondTask = @{TITLE:@"mid-morning", DESCRIPTION:@"eat breakfast", DATE:@"2014-12-03", COMPLETION:@"NO"};
    [taskData addObject:secondTask];
    
    return taskData;
}

@end



