//
//  MTPerformanceModel.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/14.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTPerformanceModel.h"

@implementation MTPerformanceModel

- (id)initWithCPU:(NSNumber *)cpu MEM:(NSNumber *)mem FPS:(NSNumber *)fps atTime:(NSDate *)time {
    self = [super init];
    
    if (self) {
        _cpuValue = cpu;
        _memValue = mem;
        _fpsValue = fps;
        _sampleTime = time;
    }
    
    return self;
}

@end
