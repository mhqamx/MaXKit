//
//  MXBlockReviewViewController.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/15.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
// block使用, 控制器的执行某个方法时调用
// 网络请求参数返回使用
@interface MXBlockReviewViewController : MXBaseViewController
@property (nonatomic, copy) void (^buttonBlock)(void);
@end

NS_ASSUME_NONNULL_END
