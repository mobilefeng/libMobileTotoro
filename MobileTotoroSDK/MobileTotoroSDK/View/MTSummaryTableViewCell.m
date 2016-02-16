//
//  MTSummaryTableViewCell.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/1.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTSummaryTableViewCell.h"

// Macro
#import "MTMacro.h"

// View
#import "MTSummaryView.h"

#import "MTPerformanceManager.h"

@interface MTSummaryTableViewCell ()

@property (nonatomic, strong) MTSummaryView *cpuView;
@property (nonatomic, strong) MTSummaryView *memView;

@end

@implementation MTSummaryTableViewCell

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // cpuView
        CGRect cpuViewRect = CGRectMake((kMTWindowWidth/2-kMTSummaryViewSize)/2,
                                        (kMTSummaryCellHeight-kMTSummaryViewSize)/2,
                                        kMTSummaryViewSize,
                                        kMTSummaryViewSize);
        self.cpuView = [[MTSummaryView alloc] initWithFrame:cpuViewRect type:eMTViewTypeCPU];
        [self.contentView addSubview:self.cpuView];
        
        // memView
        CGRect memViewRect = CGRectMake((kMTWindowWidth/2-kMTSummaryViewSize)/2+kMTWindowWidth/2,
                                        (kMTSummaryCellHeight-kMTSummaryViewSize)/2,
                                        kMTSummaryViewSize,
                                        kMTSummaryViewSize);
        self.memView = [[MTSummaryView alloc] initWithFrame:memViewRect type:eMTViewTypeMEM];
        [self.contentView addSubview:self.memView];
        
        // 中间 竖分割线
        CGRect midSepaLineRect = CGRectMake(kMTWindowWidth/2,
                                     kMTSummaryCellHeight*0.03,
                                     0.5,
                                     kMTSummaryCellHeight*0.94);
        UIView *midSepaLineView = [[UIView alloc] initWithFrame:midSepaLineRect];
        midSepaLineView.backgroundColor = UIColorFromRGB(0xE6E8EA);
        [self.contentView addSubview:midSepaLineView];
        
        // 底部 横分割线
        CGRect bottomSepaLineRect = CGRectMake(kMTWindowWidth*0.01,
                                               kMTSummaryCellHeight-0.5,
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

#pragma mark - Data
- (void)updateSummaryCell {
    // CPU
    NSNumber *cpuValue = [NSNumber numberWithFloat:[MTPerformanceManager sharedInstance].cpuCurrent];
    [self.cpuView updateViewWithDate:cpuValue];
    
    // MEM
    NSNumber *memValue = [NSNumber numberWithFloat:[MTPerformanceManager sharedInstance].memCurrent];
    [self.memView updateViewWithDate:memValue];
}

@end
