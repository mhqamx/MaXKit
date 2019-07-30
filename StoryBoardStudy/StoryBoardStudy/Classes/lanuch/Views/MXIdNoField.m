//
//  MXIdNoField.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/5.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXIdNoField.h"

#define SCREEN_BOUNDS               ([UIScreen mainScreen].bounds)
#define kMXIdNoInputViewHeightForiPhone (SCREEN_HEIGHT >= 812 ? 292.f:258.f)
#define kMXIdNoInputViewHeightForiPad 298.f
#define kMXIdNoInputViewButtonInterval .5f
#define kMXIdNoButtonDefaultTag 0x650100

@protocol MXIdNoInputViewDelegate <NSObject>

- (void)insertWithString:(NSString *)string;

- (void)delete;

- (void)done;

@end

@interface MXIdNoInputView : UIView

/**
 工具栏
 */
@property (nonatomic, strong) UIView * toolBarView;

/**
 完成按钮
 */
@property (nonatomic, strong) UIButton * doneBtn;

/**
 输入栏
 */
@property (nonatomic, strong) UIView * inputView;

/**
 委托
 */
@property (nonatomic, weak) id<MXIdNoInputViewDelegate> delegate;

@end

@implementation MXIdNoInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.toolBarView];
        [self.toolBarView addSubview:self.doneBtn];
        
        [self addSubview:self.inputView];
        
        UIButton *button = nil;
        for (int i = 0; i < 12; i++) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = kMXIdNoButtonDefaultTag + i;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
            [button addTarget:self action:@selector(idButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.inputView addSubview:button];
        }
        //设置"X"
        button = [self.inputView viewWithTag:(kMXIdNoButtonDefaultTag+9)];
        [button setTitle:@"X" forState:UIControlStateNormal];
        //设置"0"
        button = [self.inputView viewWithTag:(kMXIdNoButtonDefaultTag+10)];
        [button setTitle:@"0" forState:UIControlStateNormal];
        //设置删除键
        button = [self.inputView viewWithTag:(kMXIdNoButtonDefaultTag+11)];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_keyboard_del"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height = 47.f;
    self.toolBarView.frame = frame;
    
    frame.origin.x = frame.size.width - 75.f;
    frame.size.width = 75.f;
    self.doneBtn.frame = frame;
    
    frame = self.toolBarView.frame;
    frame.origin.y += frame.size.height;
    frame.size.height = self.bounds.size.height - frame.origin.y;
    self.inputView.frame = frame;
    
    frame = self.inputView.bounds;
    frame.size = CGSizeMake((frame.size.width-kMXIdNoInputViewButtonInterval*2)/3, (frame.size.height-kMXIdNoInputViewButtonInterval*3)/4);
    UIButton *button = nil;
    for (int i=0; i<12; i++) {
        button = [self.inputView viewWithTag:kMXIdNoButtonDefaultTag+i];
        button.frame = frame;
        
        if (i > 0 && (i+1) % 3 == 0) {
            frame.origin.x = 0.f;
            frame.origin.y += frame.size.height + kMXIdNoInputViewButtonInterval;
        }else{
            frame.origin.x += frame.size.width + kMXIdNoInputViewButtonInterval;
        }
    }
}

- (void)idButtonClick:(id)sender {
    
    int index = (int)([sender tag] - kMXIdNoButtonDefaultTag);
    switch (index) {
        case -1:
        {
            //完成键
            [self.delegate done];
        }
            break;
            
        case 11:
        {
            //删除键
            [self.delegate delete];
        }
            break;
        default:
        {
            //数字键
            [self.delegate insertWithString:[(UIButton *)sender titleLabel].text];
        }
            break;
    }
}
#pragma mark  - Getter/Setter

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] init];
        _toolBarView.backgroundColor = [UIColor grayColor];
    }
    return _toolBarView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.tag = kMXIdNoButtonDefaultTag-1;
        _doneBtn.backgroundColor = self.toolBarView.backgroundColor;
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [_doneBtn addTarget:self action:@selector(idButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor redColor];
    }
    return _inputView;
}

@end

@interface MXIdNoField()<MXIdNoInputViewDelegate>

@end

@implementation MXIdNoField

- (instancetype)init {
    
    if (self = [super init]) {
        [self initKeyboard];
    }
    return self;
}

- (void)initKeyboard {
    
    CGRect frame = SCREEN_BOUNDS;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        frame.size.height = kMXIdNoInputViewHeightForiPad;
    }else{
        frame.size.height = 258;
    }
    
    MXIdNoInputView *inputView = [[MXIdNoInputView alloc] initWithFrame:frame];
    inputView.delegate = self;
    self.inputView = inputView;
}

#pragma mark  - SWIdNoInputViewDelegate

- (void)insertWithString:(NSString *)string {
    
    if (self.text.length >= 18) {
        //长度超限
        return;
    }
    
    if (string.length == 0) {
        //非法输入
        return;
    }
    
    if ([string isEqualToString:@"X"] && self.text.length+1 != 18) {
        //X非最后一位
        return;
    }
    
    self.text = [self.text stringByAppendingString:string];
}

- (void)delete {
    
    if (self.text.length > 0) {
        self.text = [self.text substringToIndex:(self.text.length-1)];
    }
}

- (void)done {
    
    [self resignFirstResponder];
}

@end
