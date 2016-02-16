//
//  ViewController.m
//  MobileTotoroDemo
//
//  Created by 徐杨 on 16/2/16.
//  Copyright © 2016年 xuyang. All rights reserved.
//

#import "ViewController.h"
#import "MTLogoView.h"
#import "MTTableViewController.h"
#import "MTMacro.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = kMTBackgroundColor;
        
        // Add LogoView
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        MTLogoView *logo = [[MTLogoView alloc] initWithFrame:CGRectMake(0.5*screenBounds.size.width,
                                                                       0.5*screenBounds.size.height,
                                                                       0.2*screenBounds.size.width,
                                                                       0.2*screenBounds.size.width)];
        logo.doubleTapBlock = ^{
            MTTableViewController *tableViewController = [[MTTableViewController alloc] init];
            [self.navigationController pushViewController:tableViewController animated:YES];
        };
        [self.view addSubview:logo];
    }
    return self;
}

@end


@implementation NavigaitionController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self.navigationBar setTintColor:kMTThemeColor];
        [[UINavigationBar appearance] setBarTintColor:kMTNavColor];
        
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    viewController.navigationItem.backBarButtonItem = item;
}

@end
