//
//  ICTraceLogFormatter.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICTraceLogFormatter.h"
#import "ICTraceLogManager.h"
#import "ICTraceLogBase.h"

@implementation ICTraceLogFormatter

#pragma mark - Formatting
+ (NSString *)tracelog:(NSString *)identifier type:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum textFormat:(NSString *)format withParameters:(va_list)valist
{
    @autoreleasepool {
     
        // make the log text
        NSString * formattedString = nil;
        if (format)
        {
            formattedString = [[NSString alloc] initWithFormat:format arguments:valist];
        }
        else
        {
            formattedString = @"";
        }
        
        // Identifier
        NSString *identifierStr = ([identifier length] > 0) ? [NSString stringWithFormat:@"  [%@]  ", identifier] : @"";
        
        // With basic info
        NSMutableString *resultString = [[NSMutableString alloc] initWithFormat:@"[%@] %@ ", type, formattedString];
        
        // With detail info
        if ([type isEqualToString:TRACE_LEVEL_ERROR] || [type isEqualToString:TRACE_LEVEL_FATAL])
        {
            [resultString appendFormat:@"\n ****** %s LINE:%d ****** \n", selName, lineNum];
        }
        
        // Format with time
        NSString *timeStr = getTraceTimeStampStr();
        NSString *finalLogStr = [[NSString alloc] initWithFormat:@"%@%@ %@ \r\n",identifierStr, timeStr, resultString];
        
        return finalLogStr;
    }
}

+ (NSString *)tracelog:(NSString *)identifier type:(NSString *)type selName:(const char *)selName lineNum:(int)lineNum text:(NSString *)format, ...
{
    NSString *result = nil;
    
    if (format)
    {
        va_list arg;
        va_start(arg, format);
        result = [self tracelog:identifier type:type selName:selName lineNum:lineNum textFormat:format withParameters:arg];
        va_end(arg);
    }
    else
    {
        result = [self tracelog:identifier type:type selName:selName lineNum:lineNum textFormat:nil withParameters:nil];
    }
    
    return result;
}

@end
