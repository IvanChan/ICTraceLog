//
//  ICTraceLogIOWriterConsole.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICTraceLogIOWriterConsole.h"

@interface ICTraceLogIOWriterConsole ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ICTraceLogIOWriterConsole

#pragma mark - Init & Dealloc
+ (ICTraceLogIOWriterConsole *)defaultIOWriterConsole
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
       self.queue = dispatch_queue_create("com.ucweb.TraceLogIOWriterConsole", nil);
    }
    
    return self;
}

#pragma mark - IOWriter Protocol
- (BOOL)write:(NSString *)data
{
    __block BOOL ret = NO;
    dispatch_sync(self.queue, ^{
        
    if ([data length] > 0)
    {
        printf("%s", [data UTF8String]);
        ret = YES;
    }
    });
    
    return ret;
}

- (void)flush
{

}

@end
