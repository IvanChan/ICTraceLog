//
//  ICTraceLogCenter.m
//  ICTraceLog
//
//  Created by _ivanC on 03/14/2013.
//  Copyright (c) 2017 _ivanC. All rights reserved.
//

#import "ICTraceLogCenter.h"

@interface ICTraceLogCenter ()

@property (nonatomic, strong) NSMutableDictionary *logItemList;

@end

@implementation ICTraceLogCenter

#pragma mark - Init & Dealloc
+ (instancetype)defaultCenter
{
    static ICTraceLogCenter *s_instance = nil;
    
    @synchronized(self) {
 
            if (!s_instance)
            {
                s_instance = [[self alloc] init];
            }
    }
    return s_instance;
}

#pragma mark - Getters
- (NSMutableDictionary *)logItemList
{
    if (_logItemList == nil)
    {
        _logItemList = [[NSMutableDictionary alloc] init];
    }
    return _logItemList;
}

- (ICTraceLogManager *)logItemWithTraceIdentifier:(NSString *)identifier
{
    ICTraceLogManager *manager = nil;
    
    @synchronized(self) {

        if (identifier)
        {
            manager = self.logItemList[identifier];
        }
    }

    return manager;
}

#pragma mark - Register
- (ICTraceLogManager *)registerTraceIdentifier:(NSString *)identifier
{
    ICTraceLogManager *manager = nil;

    @synchronized(self) {
         if (identifier)
         {
             manager = [[ICTraceLogManager alloc] initWithIdentifier:identifier];
             self.logItemList[identifier] = manager;
         }
     }

    return manager;
}


- (void)unregisterTraceIdentifier:(NSString *)identifier
{
    @synchronized(self) {
    
        if (identifier)
        {
            [self.logItemList removeObjectForKey:identifier];
        }
    }
}

@end
