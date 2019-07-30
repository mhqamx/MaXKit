//
//  MXChatInputTableViewCell.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXChatInputTableViewCell.h"

@implementation MXChatInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
