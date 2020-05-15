//
//  MXAddressPickViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/5/1.
//  Copyright © 2020 马霄. All rights reserved.
//

#import "MXAddressPickViewController.h"
#import "JHAddressPickView.h"

@interface MXAddressPickViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UILabel *codeLabel;
@end

@implementation MXAddressPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省市区";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textfield = [[UITextField alloc] initWithFrame:CGRectMake(50.f, SCREEN_HEIGHT *0.25, SCREEN_WIDTH - 100, 40.f)];
    self.textfield.delegate = self;
    self.textfield.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.textfield];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, SCREEN_HEIGHT*0.5f, SCREEN_WIDTH - 100.f, 40.f)];
    self.codeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.codeLabel.layer.borderWidth = 0.5f;
    [self.view addSubview:self.codeLabel];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];

    
}

@end
