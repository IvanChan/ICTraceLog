//
//  TraceLogManager.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICTraceLogManager.h"
#import "ICTraceLogFormatter.h"

#import "ICTraceLogIOWriterConsole.h"
#import "ICTraceLogIOWriterFile.h"

#import <UIKit/UIKit.h>

#define TRACE_LOG_CONFIG_LEVEL      @"level"
#define TRACE_LOG_CONFIG_OUTPUT     @"output"

#define TRACE_LOG_CONFIG_FILE_NAME @"tracelog_config.plist"

@interface ICTraceLogManager ()

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSArray *loggingLevelArray;

@property (nonatomic, copy) NSString *configPath;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSMutableArray *IOWriters;

@end

@implementation ICTraceLogManager

#pragma mark - Init & Dealloc
+ (ICTraceLogManager *)defaultManager
{
    __strong static ICTraceLogManager *s_manager = nil;

    @synchronized(self)
    {
        if (!s_manager)
        {
            NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *defaultConfigPath = [[documentsPaths firstObject] stringByAppendingPathComponent:TRACE_LOG_CONFIG_FILE_NAME];
            s_manager = [[ICTraceLogManager alloc] initWithConfigPath:defaultConfigPath];
            [s_manager addDefaultIOWriterWithIdentifier:TRACE_OUTPUT_FILE];
        }
    }
    return s_manager;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init])
    {
        _identifier = [identifier copy];
        [self setupManager];
    }
    
    return self;
}

- (instancetype)initWithConfigPath:(NSString *)configPath
{
    if (self = [super init])
    {
        _configPath = [configPath copy];
        [self setupManager];
    }
    
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupManager];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup
- (void)setupManager
{
    static int count = 0;
    NSString *queueName = [NSString stringWithFormat:@"com.ucweb.TraceLog%d", ++count];
    _queue = dispatch_queue_create([queueName UTF8String], nil);
    
    [self setupDefaultConfig];
    [self updateConfigFromFile];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - Attributes
- (void)addIOWriter:(id<ICTraceLogIOWriter>)writer;
{
    dispatch_sync(self.queue, ^{
        
        [self.IOWriters addObject:writer];
    });
}

- (void)addDefaultIOWriterWithIdentifier:(NSString *)identifier;
{
    dispatch_sync(self.queue, ^{
        
        NSString *targetIdentifier = [identifier uppercaseString];
        if ([targetIdentifier isEqualToString:TRACE_OUTPUT_CONSOLE])
        {
            [self.IOWriters addObject:[ICTraceLogIOWriterConsole defaultIOWriterConsole]];
        }
        else if ([targetIdentifier isEqualToString:TRACE_OUTPUT_FILE])
        {
            [self.IOWriters addObject:[ICTraceLogIOWriterFile defaultIOWriterFile]];
        }
    });
}

- (void)removeAllIOWriter
{
    dispatch_sync(self.queue, ^{
        
        [self.IOWriters removeAllObjects];
    });
}

- (NSArray *)AllIOWriters
{
    __block NSArray *allIOWriters = nil;
    dispatch_sync(self.queue, ^{
        
        allIOWriters = [self.IOWriters copy];
        
    });
    
    return allIOWriters;
}

- (NSMutableArray *)IOWriters
{
    if (_IOWriters == nil)
    {
        _IOWriters = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _IOWriters;
}

#pragma mark - Notifications
- (void)receiveDidBecomeActiveNotification:(NSNotification *)notification
{
    [self updateConfigFromFile];
}

#pragma mark - Config
- (void)resetLoggingLevelWithString:(NSString *)levelStr
{
    dispatch_sync(self.queue, ^{
        
    if ([levelStr length] > 0)
    {
        self.loggingLevelArray = [levelStr componentsSeparatedByString:@"|"];
    }
        
    });
}

- (void)resetLoggingLevelWithArray:(NSArray *)levelArray
{
    dispatch_sync(self.queue, ^{

        self.loggingLevelArray = levelArray;
 
    });
}

- (void)setupDefaultConfig
{
    [self resetLoggingLevelWithString:DEFAULT_TRACE_TYPE];
    [self addDefaultIOWriterWithIdentifier:TRACE_OUTPUT_CONSOLE];
//    [self addIOWriterWithIdentifier:TRACE_OUTPUT_FILE];
}

- (void)updateConfigFromFile
{
    do
    {
        if ([self.configPath length] <= 0)
        {
            break;
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.configPath])
        {
            // Config file NOT found
            break;
        }
        
        // Read config from file
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:self.configPath];
        
        // Set level
        NSArray *levelArray = [dict objectForKey:TRACE_LOG_CONFIG_LEVEL];
        [self resetLoggingLevelWithArray:levelArray];
        
        // Set output
        NSArray *outputArray = [dict objectForKey:TRACE_LOG_CONFIG_OUTPUT];
        [self removeAllIOWriter];
        
        for (NSString *outputType in outputArray)
        {
            [self addDefaultIOWriterWithIdentifier:outputType];
        }
        
        
    } while (0);
}

#pragma mark - Check
- (BOOL)isLoggingTypeAccepted:(NSString *)type
{
    BOOL result = NO;
    NSString *targetType = [type uppercaseString];
    if ([self.loggingLevelArray count] > 0)
    {
        for (NSString *ltype in self.loggingLevelArray)
        {
            if ([ltype isEqualToString:targetType])
            {
                result = YES;
                break;
            }
        }
    }
    
    return result;
}

#pragma mark - output
- (void)writeToOutput:(NSString *)text
{
    if ([text length] <= 0)
    {
        return;
    }
    
    dispatch_sync(self.queue, ^{
        
        for (id<ICTraceLogIOWriter> writer in self.IOWriters)
        {
            [writer write:text];
            [writer flush];
        }
    });
}

#pragma mark - Formatting
- (BOOL)tracelog:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum textFormat:(NSString *)format withParameters:(va_list)valist
{
    BOOL result = NO;
    if ([self.IOWriters count] <= 0 || ![self isLoggingTypeAccepted:type])
    {
        return result;
    }
    
    // Format
    NSString *identifierStr = self.identifierHidden ? nil : self.identifier;
    NSString *resultStr = [ICTraceLogFormatter tracelog:identifierStr type:type selName:selName lineNum:lineNum textFormat:format withParameters:valist];
    [self writeToOutput:resultStr];
    
    result = ([resultStr length] > 0);
    return result;
}

- (BOOL)tracelog:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum text:(NSString *)format, ...
{
    BOOL result = NO;
    
    if (format)
    {
        va_list arg;
        va_start(arg, format);
        result = [self tracelog:type selName:selName lineNum:lineNum textFormat:format withParameters:arg];
        va_end(arg);
    }
    else
    {
        result = [self tracelog:type selName:selName lineNum:lineNum textFormat:nil withParameters:nil];
    }
    
    return result;
}

@end
