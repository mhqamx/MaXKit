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
@property (nonatomic, strong) UILabel *dragonWinNum;
@property (nonatomic, strong) UILabel *tigerWinNum;
@property (nonatomic, assign) NSInteger dragonWinRate;
@property (nonatomic, assign) NSInteger tigerWinRate;

@property (nonatomic, strong) NSMutableArray *dragonArr;
@property (nonatomic, strong) NSMutableArray *tigerArr;
@property (nonatomic, strong) NSMutableArray *sumArr;
@property (nonatomic, strong) NSMutableArray *colorViewArr;
@property (nonatomic, assign) NSInteger sumIndex;
@end

@implementation MXDragonTigerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dragonWinRate = 0;
    self.tigerWinRate = 0;
    self.sumIndex = 0;
    
    self.dragonArr = @[].mutableCopy;
    self.tigerArr = @[].mutableCopy;
    self.sumArr = @[].mutableCopy;
    self.colorViewArr = @[].mutableCopy;
    
    
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.dragonView];
    [self.dragonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(125);
        make.width.offset(SCREEN_WIDTH/2 - 25);
        make.height.offset(200);
    }];

    [self.dragonWinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.dragonView.mas_centerX);
        make.bottom.mas_equalTo(self.dragonView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.tigerView];
    [self.tigerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dragonView.mas_right).offset(20);
        make.top.offset(125);
        make.width.mas_equalTo(self.dragonView.mas_width);
        make.height.offset(200);
    }];
    
    [self.tigerWinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tigerView.mas_centerX);
        make.bottom.mas_equalTo(self.tigerView.mas_bottom);
        make.height.mas_equalTo(20);
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
    
    UIView *dView = [[UIView alloc] init];
    dView.backgroundColor = [UIColor redColor];
    [self.view addSubview:dView];
    
    UIView *tView = [[UIView alloc] init];
    tView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:tView];
    
    [dView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.resetBtn.mas_bottom).offset(30);
    }];
    
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dView.mas_bottom);
        make.width.mas_equalTo(dView.mas_width);
        make.height.mas_equalTo(dView.mas_height);
        make.left.mas_equalTo(dView.mas_left);
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
        self.tigerWinRate++;
        
        NSDictionary *dic = @{@"num":@(TigerRandom), @"color":@"blue"};
        [self.sumArr addObject:dic];
        
        NSLog(@"Tiger Win");
    } else if (DragonRandom > TigerRandom) {
        // 龙大
        self.dragonView.backgroundColor = [UIColor redColor];
        self.dragonWinRate++;
        
        NSDictionary *dic = @{@"num":@(DragonRandom), @"color":@"red"};
        [self.sumArr addObject:dic];
        
        NSLog(@"Dragon Win");
    } else {
        // 和局
        self.tigerView.backgroundColor = [UIColor greenColor];
        self.dragonView.backgroundColor = [UIColor greenColor];
        
        self.tigerWinNum.text = @"和局";
        self.dragonWinNum.text = @"和局";
        
        NSDictionary *dic = @{@"num":@(TigerRandom), @"color":@"green"};
        [self.sumArr addObject:dic];
        
        NSLog(@"和局");
    }
    
    NSNumber *tNum = [NSNumber numberWithInteger:self.tigerWinRate];
    NSNumber *dNum = [NSNumber numberWithInteger:self.dragonWinRate];
    
    CGFloat tRate = ([tNum floatValue]/([tNum floatValue] + [dNum floatValue]));
    CGFloat dRate = ([dNum floatValue]/([tNum floatValue] + [dNum floatValue]));
    
    
    
    self.tigerWinNum.text = [NSString stringWithFormat:@"%ld %.1f%%", self.tigerWinRate, tRate*100];
    self.dragonWinNum.text = [NSString stringWithFormat:@"%ld %.1f%%", self.dragonWinRate, dRate*100];
    
    
//    for (UIView *view in self.colorViewArr) {
//        [view removeFromSuperview];
//    }
    
    if (self.sumArr.count) {
        for (NSInteger i = self.sumIndex; i < self.sumArr.count; i++) {
            UIView *wView = [[UIView alloc] init];
            wView.layer.borderColor = [UIColor whiteColor].CGColor;
            wView.layer.borderWidth = 1.f;
            NSDictionary *dict = self.sumArr[i];
            // 行
            NSInteger j = (self.sumArr.count - 1)/10;
            // 列
            NSInteger k = (self.sumArr.count - 1)%10;
            
            if ([dict[@"color"] isEqualToString:@"red"]) {
                wView.backgroundColor = [UIColor redColor];
            } else if ([dict[@"color"] isEqualToString:@"blue"]) {
                wView.backgroundColor = [UIColor blueColor];
            } else {
                wView.backgroundColor = [UIColor greenColor];
            }
            [self.view addSubview:wView];
            
//            [self.colorViewArr addObject:wView];
            
            [wView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.resetBtn.mas_bottom).offset(30 + k*20);
                make.left.mas_equalTo(40 + j*20);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
            
        }
    }
    
//    [self.colorViewArr removeAllObjects];
    self.sumIndex = self.sumArr.count;
    
    
    NSLog(@"DragonRandom ---- %d\n TigerRandom ---- %d", DragonRandom, TigerRandom);
    
}

- (void)resetBtnOnClick {
    self.dragonView.backgroundColor = [UIColor grayColor];
    self.tigerView.backgroundColor = [UIColor grayColor];
}

#pragma mark - Setter/Getter
- (UIView *)tigerView {
    if (!_tigerView) {
        _tigerView = [[UIView alloc] init];
        _tigerView.backgroundColor = [UIColor grayColor];
        _tigerView.layer.cornerRadius = 12;
        _tigerView.clipsToBounds = YES;
        
        _tigerWinNum = [[UILabel alloc] init];
        _tigerWinNum.backgroundColor = [UIColor whiteColor];
        _tigerWinNum.font = HELVETICA(14);
        
        [_tigerView addSubview:_tigerWinNum];
    }
    return _tigerView;
}

- (UIView *)dragonView {
    if (!_dragonView) {
        _dragonView = [[UIView alloc] init];
        _dragonView.backgroundColor = [UIColor grayColor];
        _dragonView.layer.cornerRadius = 12;
        _dragonView.clipsToBounds = YES;
        
        _dragonWinNum = [[UILabel alloc] init];
        _dragonWinNum.backgroundColor = [UIColor whiteColor];
        _dragonWinNum.font = HELVETICA(14);
        
        [_dragonView addSubview:_dragonWinNum];
    }
    return _dragonView;
}


@end
