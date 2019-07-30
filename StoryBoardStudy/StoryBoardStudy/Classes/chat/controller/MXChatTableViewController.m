//
//  MXChatTableViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/17.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXChatTableViewController.h"
#import "MXUserTableViewCell.h"
#import "MXStaffTableViewCell.h"
#import "MXChatInputView.h"

@interface MXChatTableViewController ()<UIGestureRecognizerDelegate, UITextViewDelegate>
/**
 输入框
 */
@property (nonatomic, strong) MXChatInputView *inputView;
/**
 导航栏高度
 */
@property (nonatomic, assign) CGFloat naviHeight;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation MXChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智障客服";
    
    self.dataSource = @[].mutableCopy;
    
    self.view.backgroundColor = RGB(231, 231, 231);
    
    // 注册键盘的通知hide or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configUI];
}

- (void)configUI {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.tableView.userInteractionEnabled = YES;
    
    self.inputView = [[MXChatInputView alloc] initWithFrame:CGRectMake(0, self.tableView.mj_h - INPUTVIEWHEIGHT, SCREEN_WIDTH, INPUTVIEWHEIGHT)];
    [self.inputView.sendBtn addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedAction:)];
    // 需要遵守协议：UIGestureRecognizerDelegate
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}

#pragma mark 获取视图控制器
- (__kindof UITableViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                                    withStoryboardName:(NSString *)sbName{
    
    if (sbName.length == 0 || identifier.length == 0) {
        return nil;
    }
    
    UIStoryboard *storyboard = nil;
    UITableViewController *controller = nil;
    @try {
        storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    } @finally {
        return controller;
    }
}

#pragma mark -
#pragma mark - PrivateMethod
- (void)sendBtnOnClick {
    NSLog(@"%s", __func__);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MXStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MXStaffID" forIndexPath:indexPath];
        
        return cell;
    }
    if (indexPath.row == 1) {
        MXUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MXUserID" forIndexPath:indexPath];
        return cell;
    }
    return [MXUserTableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    if (indexPath.row == 1) {
        return 80;
    }
    return SCREEN_HEIGHT - 100 - 80 - 64 - 60;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [self.view endEditing:YES];
}

- (void)tapGesturedAction:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

#pragma mark - Notification
// 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti {
    // 咱们取自己需要的就好了
    CGRect rec = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 小于，说明覆盖了输入框
    if ([UIScreen mainScreen].bounds.size.height - rec.size.height < self.inputView.frame.origin.y + self.inputView.frame.size.height)
    {
        // 把我们整体的View往上移动
        CGRect tempRec = self.view.frame;
        tempRec.origin.y = - (rec.size.height);
    }
    // 1.view和tableview联动, inputview位置可以不变
    // 2.view不动, tableview和inputview联动
    // tableviewcontroller self.view == self.tableview 只能inputView联动
    self.view.frame = CGRectMake(0, self.naviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - rec.size.height - self.naviHeight);
    
    // 由于可见的界面缩小了，TableView也要跟着变化Frame
    if (IPHONE_896 || IPHONE_812) {
        self.tableView.frame = CGRectMake(0, rec.size.height - 34.f, SCREEN_WIDTH, SCREEN_HEIGHT - (self.naviHeight - 34.f) - rec.size.height - 60);
    } else {
//        self.tableView.frame = CGRectMake(0, rec.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - rec.size.height - 60);
    }
    self.inputView.frame = CGRectMake(0, self.view.mj_h - INPUTVIEWHEIGHT - self.naviHeight, SCREEN_WIDTH, INPUTVIEWHEIGHT);

    if (self.dataSource.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// 监听键盘隐藏
- (void)keyboardHide:(NSNotification *)noti {
    self.view.frame = CGRectMake(0, self.naviHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSInteger line = 0;
    if (SCREEN_WIDTH == 414) {
        line = 18;
    } else if (SCREEN_WIDTH == 375) {
        line = 16;
    }
    // 高度要保留
    CGFloat height = (self.inputView.inputTF.text.length/line)*18;
    height = height>44.f?44.f:height;
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT - self.naviHeight - height, SCREEN_WIDTH, INPUTVIEWHEIGHT + height);
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.inputView.mj_h - self.naviHeight);
    }];
    if (self.dataSource.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==self.inputView.inputTF && [text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSString *valueStr = [self removeSpaceAndNewline:textView.text]; // 去除字符串中的字符和空行
        if (valueStr.length < 2) {
            return NO;
        }
        return NO;
    }
    return YES;
}


- (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *text = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text;
}

// 视图下滑键盘收起
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];//结束编辑状态，即可以关闭键盘
    NSInteger line = 16;
    if (SCREEN_WIDTH == 414) {
        line = 18;
    } else if (SCREEN_WIDTH == 375) {
        line = 16;
    }
    // 高度要保留
    CGFloat height = (self.inputView.inputTF.text.length/line)*18;
    height = height>44.f?44.f:height;
    if (IPHONE_812 || IPHONE_896) {
        self.view.frame = CGRectMake(0, 88.f, SCREEN_WIDTH, SCREEN_HEIGHT - 88.f);
    } else {
        self.view.frame = CGRectMake(0, 64.f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.f);
    }
    [UIView animateWithDuration:0.3 animations:^{
//        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT - self.naviHeight - INPUTVIEWHEIGHT - height, SCREEN_WIDTH, INPUTVIEWHEIGHT + height);
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT - INPUTVIEWHEIGHT - 64, SCREEN_WIDTH, INPUTVIEWHEIGHT);

    }];
}

/**
 简历
 职业技能:
 1.熟练使用git, svn进行代码托管.
 2.熟练使用MVC, MVVM, 代理, Block等设计模式.
 3.熟练使用KVO, KVC消息监听模式.
 4.了解runtime运行原理
 5.熟练解析JSON
 6.熟练掌握苹果应用上架打包流程
 7.了解内存管理机制
 8.熟练掌握autolayout, masonry布局
 
 */

@end
