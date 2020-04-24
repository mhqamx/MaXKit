//
//  MXTabBarViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/4/24.
//  Copyright © 2020 马霄. All rights reserved.
//

#import "MXTabBarViewController.h"
#import "MXBaseNavigationController.h"
#import "MXTabBarItem.h"
#import "Define.h"

#define kMXTabBarHomeMemusList                  @"HomeMenusPlist"
#define kMXTabBarItemStoryboard                 @"tabBar_item_storyboard_identifier"
#define kMXTabBarItemIdentifier                 @"tabBar_item_rootController_identifier"
#define kMXTabBarItemTitle                      @"tabBar_item_title"

#define kMXTabBarItemImageUrlKey                @"tabBar_item_image_url"
#define kMXTabBarItemImageHighlightUrlKey       @"tabBar_item_image_highlight_url"

@interface MXTabBarViewController ()

/**
 Home菜单列表
 */
@property (nonatomic, copy) NSArray *menusList;

@end

@implementation MXTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTabBarViewControllers];
}

- (void)setTabBarViewControllers {
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:self.menusList.count];
    for (NSDictionary *source in self.menusList) {
        UIViewController *rootController = [self instantiateViewControllerWithIdentifier:[source objectForKey:kMXTabBarItemIdentifier]
                                                                      withStoryBoardName:[source objectForKey:kMXTabBarItemStoryboard]];
        [controllers addObject:[[MXBaseNavigationController alloc] initWithRootViewController:rootController]];
        [rootController setTabBarItem:[self initializedTabBarItem:source]];
    }
    [self setViewControllers:controllers animated:YES];
}

- (MXTabBarItem *)initializedTabBarItem:(NSDictionary *)sourcesItem {
    
    MXTabBarItem *tabBarItem = [[MXTabBarItem alloc] init];
    [tabBarItem setTitle:[sourcesItem objectForKey:kMXTabBarItemTitle]];
    [tabBarItem setImage:[UIImage imageNamed:[sourcesItem objectForKey:kMXTabBarItemImage]]
                forState:UIControlStateNormal];
    [tabBarItem setImage:[UIImage imageNamed:[sourcesItem objectForKey:kMXTabBarItemImageHighlight]]
                forState:UIControlStateHighlighted];
    [tabBarItem setTitleColor:APP_COLOR_TABBAR_TITLE
                     forState:UIControlStateNormal];
    [tabBarItem setTitleColor:APP_COLOR_TABBAR_TITLE_HIGHLIGHT
                     forState:UIControlStateSelected];
    [tabBarItem setTitleFont:APP_FONT_TABBAR_TITLE
                    forState:UIControlStateNormal];
    [tabBarItem setTitleFont:APP_FONT_TABBAR_TITLE_HIGHLIGHT
                    forState:UIControlStateSelected];
    return tabBarItem;
}

#pragma mark - 获取视图控制器
- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
                                                    withStoryBoardName:(NSString *)sbName {
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
        return controller;;
    }
    
}



#pragma mark - Getter/Setter
- (NSArray *)menusList {
    if (!_menusList) {
        _menusList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMXTabBarHomeMemusList ofType:@"plist"]];
    }
    return _menusList;;
}

@end
