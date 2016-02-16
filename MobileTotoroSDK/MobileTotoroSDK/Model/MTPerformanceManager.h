//
//  MTPerformanceManager.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/14.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>
#include <sys/cdefs.h>
#import <objc/runtime.h>

@interface MTPerformanceManager : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)clear;

@property (nonatomic, strong, readonly) NSMutableArray *CPUArray;
@property (nonatomic, strong, readonly) NSMutableArray *MEMArray;

//@property (nonatomic, strong, readonly) NSMutableArray *SummaryArray;
@property (nonatomic, readonly) float cpuCurrent;
@property (nonatomic, readonly) float cpuMin;
@property (nonatomic, readonly) float cpuMax;
@property (nonatomic, readonly) float cpuMean;
@property (nonatomic, readonly) float memCurrent;
@property (nonatomic, readonly) float memMin;
@property (nonatomic, readonly) float memMax;
@property (nonatomic, readonly) float memMean;
@property (nonatomic, readonly) float duration;

@end
