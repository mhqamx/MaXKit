//
//  MXUserTableViewCell.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXUserTableViewCell.h"

@implementation MXUserTableViewCell

- (void)initialization {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.icon.backgroundColor = [UIColor redColor];
    self.icon.frame = CGRectMake(SCREEN_WIDTH - 40, 10, 30, 30);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)chatContent:(UIButton *)sender {
}

// 执行在setmodel之后 一些数据处理可以在这里做
- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark -
#pragma mark --- Getter/Setter
- (void)setChatModel:(MXChatModel *)chatModel {
    if (chatModel) {
        _chatModel = chatModel;
    }
}


@end
