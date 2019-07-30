//
//  MXChatTableViewController.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXChatTableViewController : UITableViewController
- (__kindof UITableViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                                         withStoryboardName:(NSString *)sbName;
@end

NS_ASSUME_NONNULL_END
