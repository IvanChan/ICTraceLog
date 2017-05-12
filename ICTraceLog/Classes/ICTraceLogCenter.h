//
//  ICTraceLogCenter.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICTraceLogManager.h"

@interface ICTraceLogCenter : NSObject

+ (instancetype)defaultCenter;

- (ICTraceLogManager *)registerTraceIdentifier:(NSString *)identifier;
- (void)unregisterTraceIdentifier:(NSString *)identifier;

- (ICTraceLogManager *)logItemWithTraceIdentifier:(NSString *)identifier;

@end

#define DEFAULT_TRACE_LOG_CENTER [ICTraceLogCenter defaultCenter]

#define CTLOG_ITEM(identifier) [DEFAULT_TRACE_LOG_CENTER logItemWithTraceIdentifier:identifier]

#ifdef ENABLED_TRACE_LOG

#define TLOG_DEBUG(identifier, ... ) [CTLOG_ITEM(identifier) tracelog:TRACE_LEVEL_DEBUG selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TLOG_INFO(identifier, ... ) [CTLOG_ITEM(identifier) tracelog:TRACE_LEVEL_INFO selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TLOG_WARN(identifier, ... ) [CTLOG_ITEM(identifier) tracelog:TRACE_LEVEL_WARN selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TLOG_ERROR(identifier, ... ) [CTLOG_ITEM(identifier) tracelog:TRACE_LEVEL_ERROR selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]
#define TLOG_FATAL(identifier, ... ) [CTLOG_ITEM(identifier) tracelog:TRACE_LEVEL_FATAL selName:__FUNCTION__ lineNum:__LINE__ text:__VA_ARGS__]

#else

#define TLOG_DEBUG(identifier, ... )
#define TLOG_INFO(identifier, ... )
#define TLOG_WARN(identifier, ... )
#define TLOG_ERROR(identifier, ... )
#define TLOG_FATAL(identifier, ... )

#endif
