//
//  ICTraceLogIOWriter.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICTraceLogIOWriter <NSObject>

- (BOOL)write:(NSString *)data;
- (void)flush;

@end
