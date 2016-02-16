//
//  MTChartOverView.h
//  MobileTotoro
//
//  Created by 徐杨 on 16/1/23.
//  Copyright © 2016年 xuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMacro.h"

@interface MTChartOverView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(eMTViewType)type;
- (void)updateView;

@end
