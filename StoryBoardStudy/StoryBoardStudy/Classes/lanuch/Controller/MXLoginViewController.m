//
//  MXLoginViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXLoginViewController.h"
#import "MXFinanceView.h"
#import "MXidNoField.h"

@interface MXLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIImageView *usernameIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet MXFinanceView *financeView;
@property (weak, nonatomic) IBOutlet MXIdNoField *userNameT;

@end

@implementation MXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    MXIdNoField *idTF = [[MXIdNoField alloc] initWithFrame:CGRectMake(100, 150, 200, 50)];
    [self.view addSubview:idTF];
    
    self.userNameT.placeholder = @"请输入用户名";
    
    self.passwordTF.placeholder = @"请输入密码";
    
    self.financeView.titleLabel.text = @"title";
    self.financeView.desLabel.text = @"des";
    
    [self.loginButton addTarget:self action:@selector(loginButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetButton addTarget:self action:@selector(forgetButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dismissButton addTarget:self action:@selector(dismissButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma private

- (void)loginButtonOnClick {
    NSLog(@"%s", __func__);
}

- (void)forgetButtonOnClick {
    NSLog(@"%s", __func__);
}

- (void)dismissButtonOnClick {
    NSLog(@"%s", __func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
