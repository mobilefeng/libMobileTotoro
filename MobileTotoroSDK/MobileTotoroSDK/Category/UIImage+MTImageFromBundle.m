//
//  UIImage+MTImageFromBundle.m
//  MobileTotoroSDK
//
//  Created by 徐杨 on 16/2/16.
//  Copyright © 2016年 xuyang. All rights reserved.
//

#import "UIImage+MTImageFromBundle.h"

@implementation UIImage (MTImageFromBundle)

+ (UIImage *)imageNamedFromBundle:(NSString *)imgName {
    if ([[imgName componentsSeparatedByString:@"."] count] == 2) {
        imgName = [imgName componentsSeparatedByString:@"."][0];
    }
    
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"MobileTotoro.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *filePath = [bundle pathForResource:imgName ofType:@"png"];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    while ([filePath length] == 0 && scale >1) {
        NSString *scaled = [imgName stringByAppendingFormat:@"@%.0fx", scale];
        filePath = [bundle pathForResource:scaled ofType:@"png"];
        scale -= 1;
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

@end