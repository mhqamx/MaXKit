//
//  MXTabBarViewController.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/4/24.
//  Copyright © 2020 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MXTabBarViewController : UITabBarController
/**
 初始化视图

 @param identifier 视图控制器标识符
 @param storyboard 视图控制器所在storyboard的名字
 @return UIViewController
 */
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                           withStoryboardName:(NSString *)storyboard;
@end


