//
//  MTSummaryView.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/1.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMacro.h"

@interface MTSummaryView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(eMTViewType)type;
- (void)updateViewWithDate:(NSNumber *)value;

@end
