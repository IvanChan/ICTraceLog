//
//  ICTraceLogManager.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICTraceLogIOWriter.h"

// LOGGING LEVEL
#define TRACE_LEVEL_DEBUG   @"DEBUG"        // Only for DEBUG when necessary
#define TRACE_LEVEL_INFO    @"INFO"         // Just Logout some information to trace user interaction
#define TRACE_LEVEL_WARN    @"WARNING"      // Might Lead to some easy problem
#define TRACE_LEVEL_ERROR   @"ERROR"        // Might ran into some kind of ERROR and lead to unexpected result
#define TRACE_LEVEL_FATAL   @"FATAL"        // Might Cause app exit unexpectly

// Changing logging level with this string, seperated with "|", like "ERROR|FATAL"
#define DEFAULT_TRACE_TYPE @"DEBUG|INFO|WARN|ERROR|FATAL"

// IOWriter Type
#define TRACE_OUTPUT_CONSOLE    @"CONSOLE"      // Log to console
#define TRACE_OUTPUT_FILE       @"FILE"         // Write to file

@interface ICTraceLogManager : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property BOOL identifierHidden;    // Default is NO, log message will miss identifer in the beginning if set to YES

+ (ICTraceLogManager *)defaultManager;

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (instancetype)initWithConfigPath:(NSString *)configPath; // Default is "Documents/TraceLog_Config.txt"
- (void)resetLoggingLevelWithString:(NSString *)type;

- (void)addIOWriter:(id<ICTraceLogIOWriter>)writer;
- (void)removeAllIOWriter;
- (NSArray *)AllIOWriters;

- (BOOL)tracelog:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum text:(NSString *)format, ...;
- (BOOL)tracelog:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum textFormat:(NSString *)format withParameters:(va_list)valist;

@end

#define g_traceLogMgr [TraceLogManager defaultManager]

#define ENABLED_TRACE_LOG
#ifdef ENABLED_TRACE_LOG

#define TRACE_LOG_LEVEL( level, ... ) [g_traceLogMgr tracelog:level selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TRACE_LOG_DEBUG( ... ) [g_traceLogMgr tracelog:TRACE_LEVEL_DEBUG selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TRACE_LOG_INFO( ... ) [g_traceLogMgr tracelog:TRACE_LEVEL_INFO selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TRACE_LOG_WARN( ... ) [g_traceLogMgr tracelog:TRACE_LEVEL_WARN selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TRACE_LOG_ERROR( ... ) [g_traceLogMgr tracelog:TRACE_LEVEL_ERROR selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TRACE_LOG_FATAL( ... ) [g_traceLogMgr tracelog:TRACE_LEVEL_FATAL selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]

#else

#define TRACE_LOG_LEVEL( level, ... )
#define TRACE_LOG_DEBUG( ... )
#define TRACE_LOG_INFO( ... )
#define TRACE_LOG_WARN( ... )
#define TRACE_LOG_ERROR( ... )
#define TRACE_LOG_FATAL( ... )

#endif

