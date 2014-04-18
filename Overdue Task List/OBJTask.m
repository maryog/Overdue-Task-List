//
//  OBJTask.m
//  Overdue Task List
//
//  Created by Jimi Ogunyomi on 16/04/2014.
//  Copyright (c) 2014 self.crystal. All rights reserved.
//

#import "OBJTask.h"

@implementation OBJTask

-(id)init
{
    self = [self initWithData:nil];
    
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    self.title = data[TITLE];
    self.description = [data objectForKey:DESCRIPTION];
    
    NSString *date = data[DATE];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-dd-MM HH:mm"];
    
    self.date = [dateFormatter dateFromString:date];

    
    NSString *completed = [data objectForKey:COMPLETION];
    self.completed = [completed boolValue];
    
    return self;
}

@end
