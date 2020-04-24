//
//  MXTabBarItem.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/4/24.
//  Copyright © 2020 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMXTabBarItemImage          @"tabBar_item_image"
#define kMXTabBarItemImageHighlight @"tabBar_item_image_highlight"

@interface MXTabBarItem : UITabBarItem
/**
 设置标题颜色状态

 @param color 颜色
 @param state 状态
 */
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

/**
 设置标题字体

 @param font 字体
 @param state 状态
 */
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

/**
 设置图片

 @param image 图片
 @param state 状态
 */
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

/**
 设置网络图片

 @param url 图片地址
 @param state 状态
 */
- (void)setImageUrl:(NSString *)url
           forState:(UIControlState)state;
@end

