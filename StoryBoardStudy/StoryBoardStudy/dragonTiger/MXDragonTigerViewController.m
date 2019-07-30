//
//  MXDragonTigerViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/30.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXDragonTigerViewController.h"

@interface MXDragonTigerViewController ()
@property (nonatomic, strong) UIView *dragonView;
@property (nonatomic, strong) UIView *tigerView;
@property (nonatomic, strong) UILabel *winRate;
@property (nonatomic, strong) UIButton *randomBtn;
@property (nonatomic, strong) UIButton *resetBtn;

@end

@implementation MXDragonTigerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI {
    self.dragonView = [[UIView alloc] init];
    self.dragonView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dragonView];
    [self.dragonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(125);
        make.width.offset(SCREEN_WIDTH/2 - 25);
        make.height.offset(200);
    }];
    
    self.tigerView = [[UIView alloc] init];
    self.tigerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tigerView];
    [self.tigerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dragonView.mas_right).offset(20);
        make.top.offset(125);
        make.width.mas_equalTo(self.dragonView.mas_width);
        make.height.offset(200);
    }];
    
    self.randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.randomBtn setTitle:@"预测" forState:UIControlStateNormal];
    self.randomBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.randomBtn.layer.borderWidth = 1;
    [self.randomBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.randomBtn addTarget:self action:@selector(randomAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.randomBtn];
    [self.randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.resetBtn addTarget:self action:@selector(resetBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dragonView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    
}


- (void)randomAction {
    self.dragonView.backgroundColor = [UIColor grayColor];
    self.tigerView.backgroundColor = [UIColor grayColor];
    
    int DragonRandom = arc4random()%13 + 1;
    int TigerRandom = arc4random()%13 + 1;
    if (DragonRandom < TigerRandom) {
        // 虎大
        self.tigerView.backgroundColor = [UIColor blueColor];
        NSLog(@"Tiger Win");
    } else if (DragonRandom > TigerRandom) {
        // 龙大
        self.dragonView.backgroundColor = [UIColor redColor];
        NSLog(@"Dragon Win");
    } else {
        // 和局
        self.tigerView.backgroundColor = [UIColor greenColor];
        self.dragonView.backgroundColor = [UIColor greenColor];
        NSLog(@"和局");
    }
    
    NSLog(@"DragonRandom ---- %d\n TigerRandom ---- %d", DragonRandom, TigerRandom);
    
}

- (void)resetBtnOnClick {
    self.dragonView.backgroundColor = [UIColor grayColor];
    self.tigerView.backgroundColor = [UIColor grayColor];
}


@end
