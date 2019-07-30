//
//  MXBaseViewController.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXBaseViewController : UIViewController
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                                    withStoryboardName:(NSString *)sbName;
@end

NS_ASSUME_NONNULL_END
