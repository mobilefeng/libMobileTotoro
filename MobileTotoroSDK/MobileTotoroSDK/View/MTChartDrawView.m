//
//  MTChartDrawView.m
//  MobileTotoro
//
//  Created by 徐杨 on 16/1/23.
//  Copyright © 2016年 xuyang. All rights reserved.
//

#import "MTChartDrawView.h"

#import "MTMacro.h"

static const CGFloat margin = 20;
static const CGFloat borderX = margin;
static const CGFloat borderY = margin;
static const CGFloat borderWidth = kMTChartDrawViewWidth - margin;
static const CGFloat borderHeight = kMTChartCellHeight - 2*margin;
static const int scrollPageNum = 10;
static const int xLabelPerPage = 6;
static const int stepPerXLabel = 5;

@interface MTChartDrawView ()

// 背景图
@property (nonatomic, strong) UIImageView *backImageView;

// 曲线
@property (nonatomic, strong) UIScrollView *chartScrollView;
@property (nonatomic, strong) UIView *chartFullView;

// 颜色
@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, strong) UIColor *fillColor;

// 类型
@property (nonatomic) eMTViewType viewType;

// 数据
@property (nonatomic, strong) NSMutableArray *chartData;

// Smooth
@property (nonatomic) BOOL isSmooth;
@property (nonatomic) CGFloat bezierSmoothingTension;

// 数值标签
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *valuePoint;
@property (nonatomic, strong) UIView *valueLine;

@end

@implementation MTChartDrawView

- (instancetype)initWithFrame:(CGRect)frame type:(eMTViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _viewType = type;
        _isSmooth = NO;
        _bezierSmoothingTension = 0.2;
        
        // 颜色
        if (_viewType == eMTViewTypeCPU) {
            _pathColor = UIColorFromRGB(0xF59223);
            _fillColor = [_pathColor colorWithAlphaComponent:0.3];
        } else if (_viewType == eMTViewTypeMEM) {
            _pathColor = UIColorFromRGB(0x4A90E2);
            _fillColor = [_pathColor colorWithAlphaComponent:0.3];
        }
        
        // 绘制框线
        [self strokeBorder];
        
        // scrollRect
        CGRect scrollRect = CGRectMake(borderX, 0, borderWidth, kMTChartCellHeight);
        _chartScrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
        [self addSubview:_chartScrollView];
        
        // fullRect
        CGRect fullRect = CGRectMake(0, 0, borderWidth*scrollPageNum, kMTChartCellHeight);
        _chartFullView = [[UIView alloc] initWithFrame:fullRect];
        [_chartScrollView addSubview:_chartFullView];
        _chartScrollView.contentSize = fullRect.size;
        
        // 添加点击展示值的手势动作
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showValue:)];
        longPress.minimumPressDuration = 0.1;
        [_chartFullView addGestureRecognizer:longPress];
        
        // 绘制标签
        [self strokeYLabel];
        [self strokeXLabel];
    }
    return self;
}

- (void)strokeBorder {
    CGRect borderRect = CGRectMake(borderX, borderY, borderWidth, borderHeight);
    UIView *borderView = [[UIView alloc] initWithFrame:borderRect];
    borderView.backgroundColor = [UIColor clearColor];
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = UIColorFromRGB(0x9B9B9B).CGColor;
    [self addSubview:borderView];
    
    UIBezierPath *inLinePath = [UIBezierPath bezierPath];
    for (int ii = 1; ii <= 3; ii++) {
        [inLinePath moveToPoint:CGPointMake(borderX, borderY+ii*borderHeight/4)];
        [inLinePath addLineToPoint:CGPointMake(borderX+borderWidth, borderY+ii*borderHeight/4)];
    }
    CAShapeLayer *inLineLayer = [CAShapeLayer layer];
    inLineLayer.strokeColor = UIColorFromRGB(0xBBBBBB).CGColor;
    inLineLayer.lineWidth = 0.3;
    inLineLayer.path = inLinePath.CGPath;
    [self.layer addSublayer:inLineLayer];
}

- (void)strokeYLabel {
    for (int ii=0; ii<=4; ii++) {
        CGRect labelRect = CGRectMake(1, 17+(4-ii)*29, 16, 11);
        UILabel *yLabel = [[UILabel alloc] initWithFrame:labelRect];
        yLabel.text = [NSString stringWithFormat:@"%d", ii*50];
        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.textColor = UIColorFromRGB(0x9B9B9B);
        yLabel.font = [UIFont systemFontOfSize:8.0f];
        [self addSubview:yLabel];
    }
}

- (void)strokeXLabel {
    for (int index = 0; index <= xLabelPerPage*scrollPageNum; index ++) {
        CGFloat labelWidth = 20;
        CGFloat labelHeight = 8;
        CGFloat labelCenterX = index*borderWidth/xLabelPerPage + labelWidth/2;
        CGFloat labelCenterY = (borderY + borderHeight + kMTChartCellHeight)/2;
        CGFloat labelX = labelCenterX - labelWidth/2;
        CGFloat labelY = labelCenterY - labelHeight/2;
        
        UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        
        xLabel.text = [NSString stringWithFormat:@"%d", index*stepPerXLabel];
        xLabel.textAlignment = NSTextAlignmentLeft;
        xLabel.textColor = UIColorFromRGB(0x9B9B9B);
        xLabel.font = [UIFont systemFontOfSize:10];
        [self.chartFullView addSubview:xLabel];
    }
}

- (void)updateChartData:(NSArray *)chartData withFlag:(BOOL)firstFlag {
    _chartData = [NSMutableArray arrayWithArray:chartData];
    
    if (_chartData.count <= 1) {
        [[self.chartFullView.layer.sublayers copy] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self strokeXLabel];
    }
    
    UIBezierPath *path,*fill;
    if (firstFlag) {
        path = [self getLinePathFromStart:0
                                    toEnd:(int)(_chartData.count)
                            withSmoothing:self.isSmooth
                                 withFill:NO];
        fill = [self getLinePathFromStart:0
                                    toEnd:(int)(_chartData.count)
                            withSmoothing:self.isSmooth
                                 withFill:YES];
    } else {
        path = [self getLinePathFromStart:(int)(_chartData.count-1)
                                    toEnd:(int)(_chartData.count)
                            withSmoothing:self.isSmooth
                                 withFill:NO];
        fill = [self getLinePathFromStart:(int)(_chartData.count-1)
                                    toEnd:(int)(_chartData.count)
                            withSmoothing:self.isSmooth
                                 withFill:YES];
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = self.pathColor.CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1;
    pathLayer.lineJoin = kCALineJoinRound;
    [self.chartFullView.layer addSublayer:pathLayer];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = fill.CGPath;
    fillLayer.strokeColor = nil;
    fillLayer.fillColor = self.fillColor.CGColor;
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    [self.chartFullView.layer addSublayer:fillLayer];
}

- (void)clearChartData {
    
}

// 绘制区间 [startNum, endNum] 内的曲线，注意后面是闭区间
// 因为用三阶贝塞尔函数，最后一端需要endNum+1的点才能绘制
// startNum:1,2,3,...,count-2
// endNum:2,3,4,...,count-1
- (UIBezierPath *)getLinePathFromStart:(int)startNum
                                 toEnd:(int)endNum
                         withSmoothing:(BOOL)isSmooth
                              withFill:(BOOL)isFill {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if ((int)(endNum-startNum) < 1) {
        return path;
    }
    
    if (isSmooth) {
        for (int ii = startNum; ii <= endNum-1; ii++) {
            CGPoint ctrlPoint[2];
            CGPoint prevPoint, point, nextPoint, tempPoint;
            
            point = [self getPointAtIndex:ii];
            
            if (ii == startNum) {
                [path moveToPoint:point];
            }
            
            // First Control Point
            prevPoint = [self getPointAtIndex:ii-1];
            nextPoint = [self getPointAtIndex:ii+1];
            tempPoint = CGPointZero;
            
            if (ii > 1) {
                tempPoint.x = (nextPoint.x - prevPoint.x)/2;
                tempPoint.y = (nextPoint.y - prevPoint.y)/2;
            } else {
                tempPoint.x = (nextPoint.x - point.x)/2;
                tempPoint.y = (nextPoint.y - point.y)/2;
            }
            
            ctrlPoint[0].x = point.x + tempPoint.x * self.bezierSmoothingTension;
            ctrlPoint[0].y = point.y + tempPoint.y * self.bezierSmoothingTension;
            
            // Second Control Point
            prevPoint = [self getPointAtIndex:ii];
            nextPoint = [self getPointAtIndex:ii+2];
            point = [self getPointAtIndex:ii+1];
            tempPoint = CGPointZero;
            
            tempPoint.x = (nextPoint.x - prevPoint.x)/2;
            tempPoint.y = (nextPoint.y - prevPoint.y)/2;
            
            ctrlPoint[1].x = point.x - tempPoint.x * self.bezierSmoothingTension;
            ctrlPoint[1].y = point.y - tempPoint.y * self.bezierSmoothingTension;
            
            [path addCurveToPoint:point controlPoint1:ctrlPoint[0] controlPoint2:ctrlPoint[1]];
        }
    } else {
        for (int ii = startNum; ii <= endNum; ii++) {
            if (ii > startNum) {
                [path addLineToPoint:[self getPointAtIndex:ii]];
            } else {
                [path moveToPoint:[self getPointAtIndex:ii]];
            }
        }
    }
    
    if (isFill) {
        [path addLineToPoint:CGPointMake([self getPointAtIndex:endNum].x, borderY+borderHeight)];
        [path addLineToPoint:CGPointMake([self getPointAtIndex:startNum].x, borderY+borderHeight)];
        [path addLineToPoint:[self getPointAtIndex:startNum]];
    }
    
    return path;
}

// index = 1,2, ... , count
- (CGPoint)getPointAtIndex:(int)index {
    if (index <= 0 || index > self.chartData.count) {
        return CGPointMake(index*borderWidth/(xLabelPerPage*stepPerXLabel),
                           borderY+borderHeight);
    }
    
    NSNumber *valueNum = self.chartData[index-1];
    CGFloat valueFloat = valueNum.doubleValue;
    CGFloat normalizedValue = valueFloat/200;
    
    return CGPointMake(index*borderWidth/(xLabelPerPage*stepPerXLabel),
                       borderY+borderHeight-normalizedValue*borderHeight-0.5);
}

- (void)showValue:(UIGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint tapPoint = [recognizer locationInView:_chartFullView];
        int tapXValue = (int)(tapPoint.x*3.0/25.0+0.5);
        NSNumber *tapYValue;
        if (tapXValue > 0 && tapXValue <= self.chartData.count) {
            tapYValue = self.chartData[tapXValue-1];
        } else {
            return;
        }
        CGPoint tapValuePoint = [self getPointAtIndex:tapXValue];
        
        CGRect labelRect = CGRectMake(tapValuePoint.x-14, 6, 28, 14);
        _valueLabel = [[UILabel alloc] initWithFrame:labelRect];
        if (_viewType == eMTViewTypeCPU) {
            _valueLabel.text = [NSString stringWithFormat:@"%.1f%% ", tapYValue.doubleValue];
        } else if (_viewType == eMTViewTypeMEM) {
            _valueLabel.text = [NSString stringWithFormat:@"%.1fM ", tapYValue.doubleValue];
        }
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.backgroundColor = self.pathColor;
        _valueLabel.font = [UIFont systemFontOfSize:10];
        _valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_valueLabel sizeToFit];
        [_chartFullView addSubview:_valueLabel];
        
        CGRect lineRect = CGRectMake(tapValuePoint.x-0.5, margin, 1, borderHeight);
        _valueLine = [[UIView alloc] initWithFrame:lineRect];
        _valueLine.backgroundColor = self.pathColor;
        [_chartFullView addSubview:_valueLine];
        
        CGRect pointRect = CGRectMake(0, 0, 4, 4);
        _valuePoint = [[UIView alloc] initWithFrame:pointRect];
        _valuePoint.center = tapValuePoint;
        _valuePoint.layer.cornerRadius = 2.0;
        _valuePoint.layer.borderWidth = 1.0;
        _valuePoint.layer.borderColor = self.pathColor.CGColor;
        _valuePoint.layer.backgroundColor = self.fillColor.CGColor;
        [_chartFullView addSubview:_valuePoint];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_valueLabel removeFromSuperview];
        [_valueLine removeFromSuperview];
        [_valuePoint removeFromSuperview];
    }
    
}

@end
