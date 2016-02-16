//
//  MTPerformanceModel.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/14.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPerformanceModel : NSObject

@property (nonatomic, strong) NSDate *sampleTime;
@property (nonatomic, strong) NSNumber *cpuValue;
@property (nonatomic, strong) NSNumber *memValue;
@property (nonatomic, strong) NSNumber *fpsValue;

- (id)initWithCPU:(NSNumber *)cpu MEM:(NSNumber *)mem FPS:(NSNumber *)fps atTime:(NSDate *)time;

@end
