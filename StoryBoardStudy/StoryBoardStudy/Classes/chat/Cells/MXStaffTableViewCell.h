//
//  MXStaffTableViewCell.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXStaffTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatContent;

/**
 初始化
 */
- (void)initialization;

@end

NS_ASSUME_NONNULL_END
