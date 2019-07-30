//
//  MXChatInputView.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/18.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXChatInputView.h"

@implementation MXChatInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.inputTF = [[UITextView alloc] init];
        self.inputTF.layer.borderColor = [UIColor blackColor].CGColor;
        self.inputTF.font = HELVETICA(13);
        [self addSubview:self.inputTF];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.top.mas_offset(14);
            make.width.mas_equalTo(@(frame.size.width - 80));
            make.height.mas_equalTo(40);
        }];
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBtn.backgroundColor = [UIColor redColor];
        [self.sendBtn addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self addSubview:self.sendBtn];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(SCREEN_WIDTH - 60));
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}

- (void)sendBtnOnClick{
    NSLog(@"%s", __func__);
}

@end
