//
//  MTPerformanceManager.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/14.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTPerformanceManager.h"

#import "MTPerformanceModel.h"

static const NSUInteger kIntervalNum = 1;

@interface MTPerformanceManager()

@property (nonatomic, strong) NSTimer *sampleTimer;
@property (nonatomic, assign) NSTimeInterval sampleTimeInterval;
@property (nonatomic, strong) NSMutableArray *PFMArray;

@property (nonatomic, strong, readwrite) NSMutableArray *CPUArray;
@property (nonatomic, strong, readwrite) NSMutableArray *MEMArray;

@property (nonatomic, strong, readwrite) NSMutableArray *SummaryArray;
@property (nonatomic, readwrite) float cpuCurrent;
@property (nonatomic, readwrite) float cpuMin;
@property (nonatomic, readwrite) float cpuMax;
@property (nonatomic, readwrite) float cpuMean;
@property (nonatomic, readwrite) float memCurrent;
@property (nonatomic, readwrite) float memMin;
@property (nonatomic, readwrite) float memMax;
@property (nonatomic, readwrite) float memMean;
@property (nonatomic, readwrite) float duration;

@end

@implementation MTPerformanceManager


#pragma mark - Init
+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MTPerformanceManager alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _sampleTimeInterval = 1.0;
        
        _PFMArray = [NSMutableArray array];
        _CPUArray = [NSMutableArray array];
        _MEMArray = [NSMutableArray array];
        
        _cpuCurrent = 0.0f;
        _cpuMax = 0.0f;
        _cpuMin = 0.0f;
        _cpuMean = 0.0f;
        _memCurrent = 0.0f;
        _memMax = 0.0f;
        _memMin = 0.0f;
        _memMean = 0.0f;
        _duration = 0.0f;
        
        _SummaryArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:_cpuCurrent],
                         [NSNumber numberWithFloat:_cpuMin],
                         [NSNumber numberWithFloat:_cpuMax],
                         [NSNumber numberWithFloat:_cpuMean],
                         [NSNumber numberWithFloat:_memCurrent],
                         [NSNumber numberWithFloat:_memMin],
                         [NSNumber numberWithFloat:_memMax],
                         [NSNumber numberWithFloat:_memMean],nil];
    }
    
    return self;
}

#pragma mark - Public Method
- (void)start {
    self.sampleTimer = [NSTimer scheduledTimerWithTimeInterval:self.sampleTimeInterval
                                                        target:self
                                                      selector:@selector(ActivityMonitor:)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)clear {
    [_PFMArray removeAllObjects];
    [_CPUArray removeAllObjects];
    [_MEMArray removeAllObjects];
    
    _cpuCurrent = 0.0f;
    _cpuMax = 0.0f;
    _cpuMin = 0.0f;
    _cpuMean = 0.0f;
    _memCurrent = 0.0f;
    _memMax = 0.0f;
    _memMin = 0.0f;
    _memMean = 0.0f;
    _duration = 0.0f;
}

#pragma mark - Get Performance Data
- (void)ActivityMonitor:(NSTimer *)timer {
    
    _duration += self.sampleTimeInterval;
    
    _cpuCurrent = [self getCpuUsage];
    _memCurrent = [self getMemUsage];
    
    _cpuMin = (self.PFMArray.count == 0) ? _cpuCurrent : MIN(_cpuCurrent, _cpuMin);
    _memMin = (self.PFMArray.count == 0) ? _memCurrent : MIN(_memCurrent, _memMin);
    
    _cpuMax = MAX(_cpuCurrent, _cpuMax);
    _memMax = MAX(_memCurrent, _memMax);
    
    _cpuMean = (self.PFMArray.count*_cpuMean + _cpuCurrent) / (self.PFMArray.count + 1);
    _memMean = (self.PFMArray.count*_memMean + _memCurrent) / (self.PFMArray.count + 1);
    
    _SummaryArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:_cpuCurrent],
                     [NSNumber numberWithFloat:_cpuMin],
                     [NSNumber numberWithFloat:_cpuMax],
                     [NSNumber numberWithFloat:_cpuMean],
                     [NSNumber numberWithFloat:_memCurrent],
                     [NSNumber numberWithFloat:_memMin],
                     [NSNumber numberWithFloat:_memMax],
                     [NSNumber numberWithFloat:_memMean],nil];
    
    MTPerformanceModel *PFMModel = [[MTPerformanceModel alloc] initWithCPU:[NSNumber numberWithFloat:_cpuCurrent]
                                                                       MEM:[NSNumber numberWithFloat:_memCurrent]
                                                                       FPS:[NSNumber numberWithFloat:[self getFpsUsage]]
                                                                    atTime:[NSDate date]];
    
    [self.PFMArray addObject:PFMModel];
    if ([self.PFMArray count] % kIntervalNum == 0) {
        for (int index = 0; index < kIntervalNum; index ++) {
            MTPerformanceModel *modelAtIndex = [self.PFMArray objectAtIndex:(self.PFMArray.count-kIntervalNum+index)];
            NSNumber *cpuAtIndex = modelAtIndex.cpuValue;
            [self.CPUArray addObject:cpuAtIndex];
            NSNumber *memAtIndex = modelAtIndex.memValue;
            [self.MEMArray addObject:memAtIndex];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChartView" object:nil];
    }
}

- (float)getCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return 0;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

- (float)getMemUsage {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if(kernReturn != KERN_SUCCESS) {
        return 0;
    }

    return taskInfo.resident_size/1024.0/1024.0;
}

- (float)getFpsUsage {
    return 0;
}

@end
