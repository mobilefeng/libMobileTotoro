//
//  MTLogoView.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/27.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoubleTapBlock)();
typedef void(^SingleTapBlock)();

@interface MTLogoView : UIView

@property (nonatomic, copy) DoubleTapBlock doubleTapBlock;
@property (nonatomic, copy) SingleTapBlock singleTapBlock;

@end
