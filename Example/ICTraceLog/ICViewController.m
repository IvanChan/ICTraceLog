//
//  ICViewController.m
//  ICTraceLog
//
//  Created by _ivanC on 05/12/2017.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICViewController.h"
#import <ICTraceLog/ICTraceLog.h>

@interface ICViewController ()

@end

@implementation ICViewController


#define MY_LOAD_IDENTIFIER @"Chocolate"
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ICTraceLogManager *manager = [DEFAULT_TRACE_LOG_CENTER registerTraceIdentifier:MY_LOAD_IDENTIFIER];
    
    // If need to save to disk
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.log"];
    ICTraceLogIOWriterFile *fileWriter = [[ICTraceLogIOWriterFile alloc] initWithFilePath:path];
    [manager addIOWriter:fileWriter];
    
    
    TLOG_DEBUG(MY_LOAD_IDENTIFIER, @"log enabled to disk: %@\n", path);
    TLOG_INFO(MY_LOAD_IDENTIFIER, @"Just info");
    TLOG_WARN(MY_LOAD_IDENTIFIER, @"This is a warning");
    TLOG_ERROR(MY_LOAD_IDENTIFIER, @"Error will show selector & line number");
    TLOG_FATAL(MY_LOAD_IDENTIFIER, @"Fatal will do the same, And you won't see the next log");

    [manager resetLoggingLevelWithString:@"WARN|ERROR|FATAL"];
   
    TLOG_DEBUG(MY_LOAD_IDENTIFIER, @"You can't see me");
    TLOG_INFO(MY_LOAD_IDENTIFIER, @"and me");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
