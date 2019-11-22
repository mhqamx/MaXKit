//
//  MXMsgCodeView.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXBaseView.h"
#define CodeHeight 40.f
@interface MXMsgCodeView : MXBaseView
/**
 输入视图
 */
@property (nonatomic, strong) UIView *inputView;

/**
 输入完成回调
 */
@property (nonatomic, copy) void (^smsInputCompletedBlock)(NSString *code);

/**
 显示键盘
 */
- (void)becomeFirstResponder;

/**
 收起键盘
 */
- (void)resignFirstResponder;

/**
 验证码清空
 */
- (void)removeSmsCode;

@end

