//
//  MXMsgCodeView.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXMsgCodeView.h"

@interface MXMsgCodeView ()<UITextFieldDelegate>

/**
 输入框
 */
@property (nonatomic, strong) UITextField *textField;

@end

@implementation MXMsgCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
        [self addSubview:self.inputView];
        
        for (int i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:26];
            label.textAlignment = NSTextAlignmentCenter;
            [self.inputView addSubview:label];
            
            CALayer *layer = [CALayer layer];
            layer.borderColor = [UIColor blackColor].CGColor;
            layer.borderWidth = 5.f;
            
            [label.layer addSublayer:layer];
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    frame.origin.x = 57.f;
    frame.size.width -= frame.origin.x * 2;
    self.inputView.frame = frame;
    
    frame = self.inputView.bounds;
    frame.size.width = frame.size.width/(6*2 - 1);
    frame.size.height -= 10.f;
    for (UILabel *label in self.inputView.subviews) {
        label.frame = frame;
        frame.origin.x += frame.size.width*2;
        
        for (CALayer *layer in label.layer.sublayers) {
            if (layer.borderWidth == 5.f) {
                layer.frame = CGRectMake(0.f, self.inputView.frame.size.height - 5.f, frame.size.width, 5.f);
            }
        }
    }
}

- (void)inputViewFirstResponder {
    [self.textField becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        for (UILabel *label in self.inputView.subviews) {
            label.text = @"";
        }
        return;
    }
    
    for (int i = 0; i < self.inputView.subviews.count; i++) {
        UILabel *label = [self.inputView.subviews objectAtIndex:i];
        if (textField.text.length <= i) {
            label.text = @"";
            continue;
        }
        label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    
    if (textField.text.length == 6) {
        if (self.smsInputCompletedBlock) {
            self.smsInputCompletedBlock(textField.text);
        }
        [self resignFirstResponder];
    }
}

- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

- (void)resignFirstResponder {
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (!string || string.length == 0)
    {
        return YES;
    }
    
    return textField.text.length >= 6 ? NO:YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self resignFirstResponder];
    return YES;
}

#pragma mark - Getter/Setter

- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font = HELVETICA(26.f);
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)inputView {
    
    if (!_inputView) {
        
        _inputView = [[UIView alloc] init];
        _inputView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewFirstResponder)];
        [_inputView addGestureRecognizer:gesture];
    }
    return _inputView;
}

- (void)removeSmsCode {
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}


@end
