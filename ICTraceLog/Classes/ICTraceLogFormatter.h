//
//  ICTraceLogFormatter.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICTraceLogFormatter : NSObject

+ (NSString *)tracelog:(NSString *)identifier
                  type:(NSString *)type
               selName:(const char *)selName
               lineNum:(int)lineNum
            textFormat:(NSString *)format
        withParameters:(va_list)valist;

+ (NSString *)tracelog:(NSString *)identifier
                  type:(NSString *)type
               selName:(const char *)selName
               lineNum:(int)lineNum
                  text:(NSString *)format, ...;

@end
