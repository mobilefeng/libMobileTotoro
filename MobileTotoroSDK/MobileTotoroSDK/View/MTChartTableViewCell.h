//
//  MTChartTableViewCell.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/1.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMacro.h"

@interface MTChartTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         type:(eMTViewType)type;

- (void)updateChartCellWithFlag:(BOOL)firstFlag;

@end
