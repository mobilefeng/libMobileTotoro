//
//  MTChartOverView.m
//  MobileTotoro
//
//  Created by 徐杨 on 16/1/23.
//  Copyright © 2016年 xuyang. All rights reserved.
//

#import "MTChartOverView.h"

#import "MTMacro.h"

#import "MTPerformanceManager.h"

@interface MTChartOverView ()

// 类型
@property (nonatomic) eMTViewType viewType;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// Duration
@property (nonatomic, strong) UILabel *durNameLabel;
@property (nonatomic, strong) UILabel *durValueLabel;

// Min
@property (nonatomic, strong) UILabel *minNameLabel;
@property (nonatomic, strong) UILabel *minValueLabel;

// Max
@property (nonatomic, strong) UILabel *maxNameLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;

// Mean
@property (nonatomic, strong) UILabel *meanNameLabel;
@property (nonatomic, strong) UILabel *meanValueLabel;

@end

@implementation MTChartOverView

- (instancetype)initWithFrame:(CGRect)frame type:(eMTViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _viewType = type;
        
        {   // titleLabel
            CGRect titleRect = CGRectMake(6, 14, 38, 19);
            _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            if (type == eMTViewTypeCPU) {
                _titleLabel.text = @"CPU";
            } else if (type == eMTViewTypeMEM) {
                _titleLabel.text = @"MEM";
            }
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont systemFontOfSize:16.0f];
            _titleLabel.textColor = UIColorFromRGB(0x000000);
            [self addSubview:_titleLabel];
        }
        
        {   // nameLabels
            CGRect nameRect = CGRectMake(0, 79, 25, 11);
            _durNameLabel = [[UILabel alloc] initWithFrame:nameRect];
            _durNameLabel.text = @"dur:";
            _durNameLabel.textAlignment = NSTextAlignmentRight;
            _durNameLabel.font = [UIFont systemFontOfSize:8];
            _durNameLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            nameRect.origin.y += 15;
            _minNameLabel = [[UILabel alloc] initWithFrame:nameRect];
            _minNameLabel.text = @"min:";
            _minNameLabel.textAlignment = NSTextAlignmentRight;
            _minNameLabel.font = [UIFont systemFontOfSize:8];
            _minNameLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            nameRect.origin.y += 15;
            _maxNameLabel = [[UILabel alloc] initWithFrame:nameRect];
            _maxNameLabel.text = @"max:";
            _maxNameLabel.textAlignment = NSTextAlignmentRight;
            _maxNameLabel.font = [UIFont systemFontOfSize:8];
            _maxNameLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            nameRect.origin.y += 15;
            _meanNameLabel = [[UILabel alloc] initWithFrame:nameRect];
            _meanNameLabel.text = @"mean:";
            _meanNameLabel.textAlignment = NSTextAlignmentRight;
            _meanNameLabel.font = [UIFont systemFontOfSize:8];
            _meanNameLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            [self addSubview:_durNameLabel];
            [self addSubview:_minNameLabel];
            [self addSubview:_maxNameLabel];
            [self addSubview:_meanNameLabel];
        }
        
        {   // valueLabels
            CGRect valueRect = CGRectMake(25, 79, 25, 11);
            _durValueLabel = [[UILabel alloc] initWithFrame:valueRect];
            _durValueLabel.text = @"0s";
            _durValueLabel.textAlignment = NSTextAlignmentRight;
            _durValueLabel.font = [UIFont systemFontOfSize:8];
            _durValueLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            valueRect.origin.y += 15;
            _minValueLabel = [[UILabel alloc] initWithFrame:valueRect];
            _minValueLabel.textAlignment = NSTextAlignmentRight;
            _minValueLabel.font = [UIFont systemFontOfSize:8];
            _minValueLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            valueRect.origin.y += 15;
            _maxValueLabel = [[UILabel alloc] initWithFrame:valueRect];
            _maxValueLabel.textAlignment = NSTextAlignmentRight;
            _maxValueLabel.font = [UIFont systemFontOfSize:8];
            _maxValueLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            valueRect.origin.y += 15;
            _meanValueLabel = [[UILabel alloc] initWithFrame:valueRect];
            _meanValueLabel.textAlignment = NSTextAlignmentRight;
            _meanValueLabel.font = [UIFont systemFontOfSize:8];
            _meanValueLabel.textColor = UIColorFromRGB(0x9B9B9B);
            
            if (type == eMTViewTypeCPU) {
                _minValueLabel.text = @"0%";
                _maxValueLabel.text = @"0%";
                _meanValueLabel.text = @"0%";
            } else if (type == eMTViewTypeMEM) {
                _minValueLabel.text = @"0M";
                _maxValueLabel.text = @"0M";
                _meanValueLabel.text = @"0M";
            }
            
            [self addSubview:_durValueLabel];
            [self addSubview:_minValueLabel];
            [self addSubview:_maxValueLabel];
            [self addSubview:_meanValueLabel];
        }
    }
    return self;
}

- (void)updateView {
    self.durValueLabel.text = [NSString stringWithFormat:@"%.0fs", [MTPerformanceManager sharedInstance].duration];
    if (self.viewType == eMTViewTypeCPU) {
        self.minValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [MTPerformanceManager sharedInstance].cpuMin];
        self.maxValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [MTPerformanceManager sharedInstance].cpuMax];
        self.meanValueLabel.text = [NSString stringWithFormat:@"%.0f%%", [MTPerformanceManager sharedInstance].cpuMean];
    } else if (self.viewType == eMTViewTypeMEM) {
        self.minValueLabel.text = [NSString stringWithFormat:@"%.0fM", [MTPerformanceManager sharedInstance].memMin];
        self.maxValueLabel.text = [NSString stringWithFormat:@"%.0fM", [MTPerformanceManager sharedInstance].memMax];
        self.meanValueLabel.text = [NSString stringWithFormat:@"%.0fM", [MTPerformanceManager sharedInstance].memMean];
    }
}

@end
