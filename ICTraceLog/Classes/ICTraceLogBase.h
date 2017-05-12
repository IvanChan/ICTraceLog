//
//  ICTraceLogBase.h
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#ifndef  TRACELOG_BASE_H
#define  TRACELOG_BASE_H

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C"{
#endif
    
    unsigned long getTraceTickCount();
    NSString* getTraceTimeStampStr();

    long writeTraceLogToFile(NSString *path, const char * sLog, bool reset);

#ifdef __cplusplus
}
#endif

#endif
