//
//  ICTraceLogIOWriterFile.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICTraceLogIOWriter.h"

@interface ICTraceLogIOWriterFile : NSObject <ICTraceLogIOWriter>

@property NSInteger maxFileSize; // Default is 0, means unlimited

- (instancetype)initWithFilePath:(NSString *)path;

+ (ICTraceLogIOWriterFile *)defaultIOWriterFile;

@end
