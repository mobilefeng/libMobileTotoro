//
//  MTLogoView.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/12/27.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTLogoView.h"

#import "MTMacro.h"

#define kMTSuperViewFrameWidth      ([self superview].frame.size.width)
#define kMTSuperViewFrameHeight     ([self superview].frame.size.height)
#define kMTViewFrameWidth           (self.frame.size.width)
#define kMTViewFrameHeight          (self.frame.size.height)

@interface MTLogoView ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, getter=isDragging) BOOL dragging;
@property (nonatomic, getter=isShowWindow) BOOL showWindow;
@property (nonatomic) BOOL draggable;

@end

@implementation MTLogoView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization Code
        
        [self addSubview:self.logoView];
        [self addSubview:self.windowView];
        
        self.dragging = NO;
        self.showWindow = NO;
        self.draggable = YES;
        
        self.userInteractionEnabled = YES;
        
        // 添加手势操作
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapRecognizer];
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    }
    
    return self;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMTLogoSize, kMTLogoSize)];
        [_logoView setImage:[UIImage imageNamed:@"logoImage"]];
    }
    return _logoView;
}

- (UIView *)windowView {
    if (!_windowView) {
        _windowView = [[UIView alloc] init];
    }
    return _windowView;
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.dragging = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.draggable) {
        self.dragging = YES;
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:[self superview]];
        
        CGFloat leftLimit = kMTViewFrameWidth/2;
        CGFloat rightLimit = kMTSuperViewFrameWidth - kMTViewFrameWidth/2;
        CGFloat topLimit = kMTViewFrameHeight/2;
        CGFloat bottomLimit = kMTSuperViewFrameHeight - kMTViewFrameHeight/2;
        
        self.center = CGPointMake(MAX(leftLimit, MIN(rightLimit, touchPoint.x)), MAX(topLimit, MIN(bottomLimit, touchPoint.y)));
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.dragging = NO;
}

#pragma mark - Action

- (void)singleTapAction:(UITapGestureRecognizer *)recognizer {
    self.singleTapBlock();
}

- (void)doubleTapAction:(UITapGestureRecognizer *)recognizer {
    self.doubleTapBlock();
}

@end
