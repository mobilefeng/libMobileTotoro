//
//  MTChartTableViewCell.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/1.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTChartTableViewCell.h"
#import "MTChartOverView.h"
#import "MTChartDrawView.h"
#import "MTPerformanceManager.h"

@interface MTChartTableViewCell ()

@property (nonatomic, strong) NSArray *sourceDataArray;

@property (nonatomic, strong) MTChartOverView *chartOverView;
@property (nonatomic, strong) MTChartDrawView *chartDrawView;

@property (nonatomic) eMTViewType cellType;

@end

@implementation MTChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         type:(eMTViewType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = type;
        
        // overView
        CGRect overViewRect = CGRectMake((kMTWindowWidth-kMTChartOverViewWidth-kMTChartDrawViewWidth)/4,
                                         0,
                                         kMTChartOverViewWidth,
                                         kMTChartCellHeight);
        _chartOverView = [[MTChartOverView alloc] initWithFrame:overViewRect type:type];
        [self.contentView addSubview:_chartOverView];
        
        // drawView
        CGRect drawViewRect = CGRectMake((kMTWindowWidth-kMTChartOverViewWidth-kMTChartDrawViewWidth)*3/4+kMTChartOverViewWidth,
                                         0,
                                         kMTChartDrawViewWidth,
                                         kMTChartCellHeight);
        _chartDrawView = [[MTChartDrawView alloc] initWithFrame:drawViewRect type:type];
        [self.contentView addSubview:_chartDrawView];
        
        // 底部 横分割线
        CGRect bottomSepaLineRect = CGRectMake(kMTWindowWidth*0.01,
                                               kMTChartCellHeight-0.5,
                                               kMTWindowWidth*0.98,
                                               0.5);
        UIView *bottomSepaLineView = [[UIView alloc] initWithFrame:bottomSepaLineRect];
        bottomSepaLineView.backgroundColor = UIColorFromRGB(0xE6E8EA);
        [self.contentView addSubview:bottomSepaLineView];
        
        // 设置点选cell后样式不变
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier type:eMTViewTypeCPU];
}


- (void)updateChartCellWithFlag:(BOOL)firstFlag {
    [self.chartOverView updateView];
    if (self.cellType == eMTViewTypeCPU) {
        [self.chartDrawView updateChartData:[MTPerformanceManager sharedInstance].CPUArray withFlag:firstFlag];
    } else if (self.cellType == eMTViewTypeMEM) {
        [self.chartDrawView updateChartData:[MTPerformanceManager sharedInstance].MEMArray withFlag:firstFlag];
    }
}

@end
