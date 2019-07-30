//
//  MXChatInputView.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/18.
//  Copyright © 2018 马霄. All rights reserved.
//
#define INPUTVIEWHEIGHT 68

#import "MXBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXChatInputView : MXBaseView

@property (nonatomic, strong) UITextView *inputTF;

@property (nonatomic, strong) UIButton *sendBtn;

@end

NS_ASSUME_NONNULL_END
