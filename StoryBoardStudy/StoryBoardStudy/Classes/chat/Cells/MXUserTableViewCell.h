//
//  MXUserTableViewCell.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXChatModel.h"

@interface MXUserTableViewCell : UITableViewCell
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/**
 时间戳
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 聊天内容
 */
@property (weak, nonatomic) IBOutlet UIButton *chatContent;

/**
 聊天内容 超链接
 */
@property (nonatomic, strong) YYLabel *contentLabel;

/**
 聊天数据模型
 */
@property (nonatomic, strong) MXChatModel *chatModel;

/**
 初始化
 */
- (void)initialization;

@end

