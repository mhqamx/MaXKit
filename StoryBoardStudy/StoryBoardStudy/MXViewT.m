//
//  MXViewT.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXViewT.h"

@interface MXViewT ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView  *mainTableView;
@end

@implementation MXViewT

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置自定义TableView
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self addSubview:self.mainTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frame.size.height/DEFAULTCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULTCELLHEIGHT;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"FUNC --- %s\n indexPath --- %ld", __func__, indexPath.row);
//    _clickBlock(indexPath.row);
    self.clickBlock(indexPath.row);
    self.clickBlock = ^(NSInteger index) {
        NSLog(@"%s", __func__);
    };
}

@end
