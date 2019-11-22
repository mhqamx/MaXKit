//
//  MXMapUtils.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/15.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
@interface MXMapUtils : NSObject
/**
 获取手机上可用的地图列表
 
 @return 地图列表 0-自带 1-百度 2-google
 */
+ (NSArray *)getMaps;


/**
 检测权限
 
 @param completion 回调
 */
+ (void)checkAuthorizationStatusWithCompletion:(void (^)(BOOL grant))completion;

/**
 调用系统定位
 
 @param completion 回调
 */
+ (void)startUpdatingLocation:(void (^)(BOOL result, CLLocationCoordinate2D coordinate))completion;

/**
 显示地图
 
 @param mapName 地图
 @param coordinate 经纬度
 @param title 名称
 @param description 描述
 */
+ (void)showInMapWithName:(NSString *)mapName
               coordinate:(CLLocationCoordinate2D)coordinate
                    title:(NSString *)title
              description:(NSString *)description;
@end

