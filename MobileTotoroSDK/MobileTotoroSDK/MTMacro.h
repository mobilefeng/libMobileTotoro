//
//  MTMacro.h
//  MobileTotoro
//
//  Created by 徐杨 on 15/11/30.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#ifndef MTMacro_h
#define MTMacro_h

typedef NS_ENUM(NSUInteger, eMTViewType) {
    eMTViewTypeCPU = 0,
    eMTViewTypeMEM,
};

/**
 *  颜色
 */
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
#define kMTThemeColor                   (UIColorFromRGB(0xC6CAD0))
#define kMTNavColor                     (UIColorFromRGB(0xFFFFFF))
#define kMTBackgroundColor              (UIColorFromRGB(0xF7F7F7))
#define kMTBorderColor                  (UIColorFromRGB(0xE6E8EA))

#define kMTSummaryViewBackColor         (UIColorFromRGB(0xFFFFFF))
#define kMTSummaryValueColor            (UIColorFromRGB(0x414D5E))
#define kMTSummaryUnitColor             (UIColorFromRGB(0x889599))
#define kMTSummaryTitleColor            (UIColorFromRGB(0x979EA9))

#define kMTOutLineColor                 (UIColorFromRGB(0xBFBFBF))
#define kMTInLineColor                  (UIColorFromRGB(0xEFEFEF))

#define kMTChartLineColor               (UIColorFromRGB(0x43B1FC))
#define kMTChartPointColor              (UIColorFromRGB(0xFD7734))

/**
 *  尺寸
 */
// 屏幕尺寸
#define kMTWindowWidth                  ([UIScreen mainScreen].bounds.size.width)
#define kMTWindowHeight                 ([UIScreen mainScreen].bounds.size.height)

// Logo 尺寸
#define kMTLogoSize                     (0.2*kMTWindowWidth)

// SummaryView 尺寸
#define kMTSummaryViewSize              (160.0)
#define kMTSummaryCellHeight            (160.0)

// ChartView 尺寸
#define kMTChartCellHeight              (160.0)
#define kMTChartOverViewWidth           (50.0)
#define kMTChartDrawViewWidth           (270.0)


#endif /* MTMacro_h */
