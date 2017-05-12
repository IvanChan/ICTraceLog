//
//  ICTraceLogBase.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#include "ICTraceLogBase.h"

#include <sys/time.h>

unsigned long getTraceTickCount()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (unsigned long)(tv.tv_sec * 1000 + tv.tv_usec / 1000);
    
}

NSString* getTraceTimeStampStr()
{
    char zPrix[128] = {0};
    time_t now = time(NULL);
    unsigned long hsec = getTraceTickCount()/10;
    char s[64] = {0}; // 时间
    struct tm tim = *(localtime(&now));
    strftime(s, 64, "%Y-%m-%d %H:%M:%S", &tim);
    sprintf(zPrix, "%s, %04ld ", s, hsec%10000);
    
    NSString *str = [NSString stringWithUTF8String:zPrix];
    return str;
}

long writeTraceLogToFile(NSString *path, const char * sLog,  bool reset)
{
    long fileSize = -1;
    FILE * f = NULL;
    if ((f = fopen([path UTF8String], reset ? "w+":"a+")))
    {
        fwrite(sLog, 1, strlen(sLog), f);
        fileSize = ftell(f);
        fclose(f);
    }
    return fileSize;
}
