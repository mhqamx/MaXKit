//
//  MXImageViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/24.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXImageViewController.h"

@interface MXImageViewController ()
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImageView *leftImgView;
@end

@implementation MXImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天气泡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftImage = [UIImage imageNamed:@"customerSever_inputBg_right"];
    CGSize imageSize = self.leftImage.size;
    self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 120, 48)];
    // 按比例收缩视图
    self.leftImage = [self.leftImage stretchableImageWithLeftCapWidth:imageSize.width*0.5 topCapHeight:35];

    self.leftImgView.image = self.leftImage;
    [self.view addSubview:self.leftImgView];
    
    UISlider *sliderTop = [[UISlider alloc] initWithFrame:CGRectMake(100, 300, 200, 40)];
    sliderTop.maximumValue = 1.0;
    sliderTop.minimumValue = 0;
    [sliderTop addTarget:self action:@selector(TopValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderTop];
    
    UISlider *sliderleft = [[UISlider alloc] initWithFrame:CGRectMake(100, 350, 200, 40)];
    sliderleft.maximumValue = 1.0;
    sliderleft.minimumValue = 0;
    [sliderleft addTarget:self action:@selector(leftValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderleft];
    
    UISlider *sliderBottom = [[UISlider alloc] initWithFrame:CGRectMake(100, 400, 200, 40)];
    sliderBottom.maximumValue = 1.0;
    sliderBottom.minimumValue = 0;
    [sliderBottom addTarget:self action:@selector(bottomValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderBottom];
    
    UISlider *sliderRoght = [[UISlider alloc] initWithFrame:CGRectMake(100, 450, 200, 40)];
    sliderRoght.maximumValue = 1.0;
    sliderRoght.minimumValue = 0;
    [sliderRoght addTarget:self action:@selector(rightValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderRoght];
    
    UISlider *sliderHeight = [[UISlider alloc] initWithFrame:CGRectMake(100, 500, 200, 40)];
    sliderHeight.maximumValue = 48;
    sliderHeight.minimumValue = 200;
    [sliderHeight addTarget:self action:@selector(HeightValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderHeight];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 240, 200, 80)];
    [self.view addSubview:rightImg];
    
}

- (void)TopValueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.top = sender.value;
    CGSize leftSize = self.leftImage.size;
    self.leftImage = [self.leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(leftSize.height*self.top, leftSize.width*self.left, leftSize.height*self.bottom, leftSize.width*self.right) resizingMode:UIImageResizingModeStretch];
    self.leftImgView.image = self.leftImage;
    self.title = [NSString stringWithFormat:@"%f, %f, %f, %f", self.top, self.left, self.bottom, self.right];
}

- (void)leftValueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.left = sender.value;
    CGSize leftSize = self.leftImage.size;
    self.leftImage = [self.leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(leftSize.height*self.top, leftSize.width*self.left, leftSize.height*self.bottom, leftSize.width*self.right) resizingMode:UIImageResizingModeStretch];
    self.leftImgView.image = self.leftImage;
    self.title = [NSString stringWithFormat:@"%f, %f, %f, %f", self.top, self.left, self.bottom, self.right];
}

- (void)bottomValueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.bottom = sender.value;
    CGSize leftSize = self.leftImage.size;
    self.leftImage = [self.leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(leftSize.height*self.top, leftSize.width*self.left, leftSize.height*self.bottom, leftSize.width*self.right) resizingMode:UIImageResizingModeStretch];
    self.leftImgView.image = self.leftImage;
    self.title = [NSString stringWithFormat:@"%f, %f, %f, %f", self.top, self.left, self.bottom, self.right];
}

- (void)rightValueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.right = sender.value;
    CGSize leftSize = self.leftImage.size;
    self.leftImage = [self.leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(leftSize.height*self.top, leftSize.width*self.left, leftSize.height*self.bottom, leftSize.width*self.right) resizingMode:UIImageResizingModeStretch];
    self.leftImgView.image = self.leftImage;
    self.title = [NSString stringWithFormat:@"%f, %f, %f, %f", self.top, self.left, self.bottom, self.right];
}

- (void)HeightValueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    CGFloat height = sender.value;
    self.leftImgView.frame = CGRectMake(50, 100, 200, height);
}

@end
