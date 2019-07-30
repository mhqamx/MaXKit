//
//  MXBaseViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXBaseViewController.h"

@interface MXBaseViewController ()

@end

@implementation MXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 获取视图控制器
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                                    withStoryboardName:(NSString *)sbName{
    
    if (sbName.length == 0 || identifier.length == 0) {
        return nil;
    }
    
    UIStoryboard *storyboard = nil;
    UIViewController *controller = nil;
    @try {
        storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    } @finally {
        return controller;
    }
}

@end
