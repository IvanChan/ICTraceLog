//
//  ICTraceLogIOWriterConsole.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICTraceLogIOWriter.h"

@interface ICTraceLogIOWriterConsole : NSObject <ICTraceLogIOWriter>

+ (ICTraceLogIOWriterConsole *)defaultIOWriterConsole;

@end
