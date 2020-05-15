//
//  MXAddressPickView.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/5/15.
//  Copyright © 2020 马霄. All rights reserved.
//

#import "MXAddressPickView.h"


@interface MXAddressPickView()
@property (nonatomic, strong) NSArray *provinceArr;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, strong) NSArray *regionArr;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *buttonScrollView;
@property (nonatomic, strong) UIScrollView *tableViewScrollView;



@end


@implementation MXAddressPickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.3;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 380, SCREEN_WIDTH, 380)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titleLabel.text = @"请选择";
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    
    self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    self.buttonScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*1.2, 0);
    [self.contentView addSubview:self.buttonScrollView];
    
    self.tableViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 80)];
    [self.contentView addSubview:self.tableViewScrollView];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}


@end
