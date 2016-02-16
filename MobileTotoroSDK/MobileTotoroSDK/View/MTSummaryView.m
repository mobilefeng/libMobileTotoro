//
//  MTSummaryView.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/1.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTSummaryView.h"

static const double kMTSummaryValueMax = 200.0;

@interface MTSummaryView ()

// 转盘
@property (nonatomic, strong) UIImageView *dialImageView;
// 指针
@property (nonatomic, strong) UIImageView *pointerImageView;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 数值
@property (nonatomic, strong) UILabel *valueLabel;
// 单位
@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation MTSummaryView

- (instancetype)initWithFrame:(CGRect)frame type:(eMTViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        {   // 转盘 dialImageView
            CGRect dialRect = CGRectMake(9, 9, 147, 72);
            _dialImageView = [[UIImageView alloc] initWithFrame:dialRect];
            
            if (type == eMTViewTypeCPU) {
                _dialImageView.image = [UIImage imageNamed:@"dialCPU"];
            } else if (type == eMTViewTypeMEM) {
                _dialImageView.image = [UIImage imageNamed:@"dialMEM"];
            }
            
            [self addSubview:_dialImageView];
        }
        
        {   // 指针 pointerImageView
            CGRect pointerRect = CGRectMake(11, 75, 140, 8);
            _pointerImageView = [[UIImageView alloc] initWithFrame:pointerRect];
            
            _pointerImageView.image = [UIImage imageNamed:@"pointer"];
            
            [self addSubview:_pointerImageView];
        }
        
        {   // 标题 titleLabel
            CGRect titleRect = CGRectMake(20, 90, 120, 16);
            _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            
            if (type == eMTViewTypeCPU) {
                _titleLabel.text = @"CPU Usage";
            } else if (type == eMTViewTypeMEM) {
                _titleLabel.text = @"Memory Usage";
            }
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = UIColorFromRGB(0xCCCCCC);
            _titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            [self addSubview:_titleLabel];
        }
        
        {   // 数值 valueLabel
            CGRect valueRect = CGRectMake(9, 114, 64, 28);
            _valueLabel = [[UILabel alloc] initWithFrame:valueRect];
            
            _valueLabel.text = @"199.9";
            _valueLabel.textAlignment = NSTextAlignmentRight;
            _valueLabel.textColor = UIColorFromRGB(0x000000);
            _valueLabel.font = [UIFont systemFontOfSize:24.0f];
            
            [self addSubview:_valueLabel];
        }
        
        {   // 单位 unitLabel
            CGRect unitRect = CGRectMake(77, 123, 72, 17);
            _unitLabel = [[UILabel alloc] initWithFrame:unitRect];
            
            if (type == eMTViewTypeCPU) {
                _unitLabel.text = @"% (2 cores)";
            } else if (type == eMTViewTypeMEM) {
                _unitLabel.text = @"M of 1024M";
            }
            _unitLabel.textAlignment = NSTextAlignmentLeft;
            _unitLabel.textColor = UIColorFromRGB(0x9B9B9B);
            _unitLabel.font = [UIFont systemFontOfSize:12.0f];
            
            [self addSubview:_unitLabel];
        }
        
    }
    return self;
}

- (void)updateViewWithDate:(NSNumber *)value {
    
    // update valueLabel
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", value.doubleValue];
    
    // update pointerImageView
    if (value.doubleValue >= 0.0 && value.doubleValue <= kMTSummaryValueMax) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * value.doubleValue / kMTSummaryValueMax);
        self.pointerImageView.transform = rotate;
    }
    
}

@end
