//
//  MXBaseNavigationController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXBaseNavigationController.h"

@interface MXBaseNavigationController ()

@end

@implementation MXBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
}

@end
