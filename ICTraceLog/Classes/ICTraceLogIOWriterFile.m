//
//  ICTraceLogIOWriterFile.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICTraceLogIOWriterFile.h"
#import "ICTraceLogBase.h"

#define TRACE_LOG_DEFAULT_FILE_NAME @"TraceLog.log"

@interface ICTraceLogIOWriterFile ()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ICTraceLogIOWriterFile

#pragma mark - Init & Dealloc
- (instancetype)initWithFilePath:(NSString *)path
{
    if (self = [super init])
    {
        self.filePath = path;
        self.buffer = [[NSMutableArray alloc] init];
        self.queue = dispatch_queue_create("com.ucweb.TraceLogIOWriterFile", nil);
    }
    
    return self;
}

+ (ICTraceLogIOWriterFile *)defaultIOWriterFile
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *defaultLogFilePath = [[documentsPaths firstObject] stringByAppendingPathComponent:TRACE_LOG_DEFAULT_FILE_NAME];
    
    return [[self alloc] initWithFilePath:defaultLogFilePath];
}

#pragma mark - IOWriter Protocol
- (BOOL)write:(NSString *)data
{
    __block BOOL ret = NO;
    
    dispatch_sync(self.queue, ^{
        
    if ([self.filePath length] > 0 && [data length] > 0)
    {
        [self.buffer addObject:data];
        ret = YES;
    }
    });
    
    return ret;
}

- (void)flush
{
    dispatch_sync(self.queue, ^{
        
        static bool reset = false;
        for (NSString *data in self.buffer)
        {
            long fileSize = writeTraceLogToFile(self.filePath, [data UTF8String], reset);
            reset = (self.maxFileSize > 0 && fileSize > self.maxFileSize);
        }
        
        [self.buffer removeAllObjects];
        
    });
}


@end
