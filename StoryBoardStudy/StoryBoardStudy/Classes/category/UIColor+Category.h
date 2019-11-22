//
//  UIColor+Category.h
//  UIKits
//
//  Created by leo on 2017/5/11.
//  Copyright © 2017年 itollei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/**
 16进制颜色转换

 @param hexString 16进制颜色
 @return UIColor
 */
+ (UIColor *)colorWithHex:(NSString *)hexString;

@end
