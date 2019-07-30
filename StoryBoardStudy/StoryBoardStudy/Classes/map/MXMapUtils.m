//
//  MXMapUtils.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/15.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXMapUtils.h"
#import <MapKit/MapKit.h>
#import <JZLocationConverter/JZLocationConverter.h>
#define kiOSUrl @"map://"
#define kGaodeUrl @"iosmap://"
#define kBaiduUrl @"baidumap://"
#define kGoogleUrl @"comgooglemaps://"
#define APP_SCHEME_URL @"tielingbank"

@interface MXMapUtils()<CLLocationManagerDelegate>

/**
 地图列表
 */
@property (nonatomic, strong) NSMutableDictionary *maps;

/**
 定位管理类
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 请求定位权限完成
 */
@property (nonatomic, copy) void(^requestLocationAuthorizationCompletion)(BOOL result);

/**
 定位完成
 */
@property (nonatomic, copy) void (^locationCompletion)(BOOL result, CLLocationCoordinate2D coordinate);

@end

@implementation MXMapUtils

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Method
+ (instancetype)manager {
    static MXMapUtils *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [[MXMapUtils alloc] init];
    });
    return map;
}

+ (NSArray *)getMaps {
    return [[[MXMapUtils manager].maps allKeys] copy];
}

+ (void)checkAuthorizationStatusWithCompletion:(void (^)(BOOL))completion {
    [[MXMapUtils manager] requestLocationAuthorization:completion];
}

+ (void)startUpdatingLocation:(void (^)(BOOL, CLLocationCoordinate2D))completion {
    [[MXMapUtils manager] startUpdatingLocation:completion];
}

#pragma mark - Private
- (void)startUpdatingLocation:(void (^)(BOOL result, CLLocationCoordinate2D coordinate))completion{
    
    self.locationCompletion = completion;
    __weak __typeof(self) weakSelf = self;
    [self requestLocationAuthorization:^(BOOL result) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (result) {
            
            [strongSelf.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [strongSelf.locationManager setDistanceFilter:5.f];
            [strongSelf.locationManager startUpdatingLocation];
        }else{
            
            [weakSelf locationManager:weakSelf.locationManager didFailWithError:[NSError errorWithDomain:@"定位权限未开启" code:kCLAuthorizationStatusDenied userInfo:nil]];
        }
    }];
}
- (void)requestLocationAuthorization:(void (^)(BOOL result))completion {
    self.requestLocationAuthorizationCompletion = completion;
    
    if (![CLLocationManager locationServicesEnabled]) {
        self.requestLocationAuthorizationCompletion(NO);
        self.requestLocationAuthorizationCompletion = NULL;
        return;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            {
                self.requestLocationAuthorizationCompletion(YES);
                self.requestLocationAuthorizationCompletion = NULL;
            }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            // 初次使用定位
            [self.locationManager requestWhenInUseAuthorization];
        }
            break;
        default:
        {
            self.requestLocationAuthorizationCompletion(NO);
            self.requestLocationAuthorizationCompletion = NULL;
        }
            break;
    }
}

- (void)showInMapWithName:(NSString *)mapName
               coordinate:(CLLocationCoordinate2D)coordinate
                    title:(NSString *)title
              description:(NSString *)description {
    NSString *mapScheme = [self.maps objectForKey:mapName];
    // 左边需转换
    if ([mapScheme isEqualToString:kGaodeUrl]) {
        [self showInGaodeMap:coordinate title:title description:description];
    } else if ([mapScheme isEqualToString:kBaiduUrl]) {
        [self showInBaiduMap:coordinate title:title description:description];
    } else if ([mapScheme isEqualToString:kGoogleUrl]) {
        [self showInGoogleMap:coordinate title:title description:description];
    } else {
        [self showInIOS:coordinate title:title description:description];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // 定位权限变更
    if (!self.requestLocationAuthorizationCompletion) {
        return;
    }
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.requestLocationAuthorizationCompletion(YES);
            self.requestLocationAuthorizationCompletion = NULL;
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            // 刚请求权限后第一次返回始终为此值 需过滤
        }
            break;
            
        default:
        {
            self.requestLocationAuthorizationCompletion(NO);
            self.requestLocationAuthorizationCompletion = NULL;
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败:%@", error);
    if (self.locationCompletion) {
        self.locationCompletion(NO, CLLocationCoordinate2DMake(0.f, 0.f));
        self.locationCompletion = NULL;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    if (location) {
        [manager stopUpdatingLocation];
        NSLog(@"定位成功");
        
        // iOS 系统定位SDK为WGS-84坐标系
        CLLocationCoordinate2D coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        NSLog(@"latitude ----- %f, longitude ----- %f", coordinate2D.latitude, coordinate2D.longitude);
        
        if (self.locationCompletion) {
            self.locationCompletion(YES, coordinate2D);
            self.locationCompletion = NULL;
        }
    }
}

#pragma mark 调用地图显示
- (void)showInIOS:(CLLocationCoordinate2D)coordinate title:(NSString *)title description:(NSString *)description{
    
    //BD-09转WGS-84
    coordinate = [JZLocationConverter bd09ToWgs84:coordinate];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    destination.name = title;
    
    [MKMapItem openMapsWithItems:@[destination] launchOptions:nil];
    
}

- (void)showInGaodeMap:(CLLocationCoordinate2D)coordinate title:(NSString *)title description:(NSString *)description {
    
    NSString *url = @"iosamap://viewMap?sourceApplication=%@&poiname=%@&lat=%f&lon=%f&dev=0";
    
    //BD-09转GCJ-02
    coordinate = [JZLocationConverter bd09ToGcj02:coordinate];
    NSString *routeString = [[NSString stringWithFormat:url,APP_SCHEME_URL, title, coordinate.latitude, coordinate.longitude, title, description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeString]];
}

- (void)showInBaiduMap:(CLLocationCoordinate2D)coordinate title:(NSString *)title description:(NSString *)description {
    
    NSString *url = @"baidumap://map/marker?location=%@,%@&title=%@&content=%@&coord_type=gcj02";
    
    //BD-09转GCJ-02 百度巨坑 百度手机地图居然用的国标经纬度
    coordinate = [JZLocationConverter bd09ToGcj02:coordinate];
    NSString *routeString = [[NSString stringWithFormat:url, [NSString stringWithFormat:@"%f", coordinate.latitude], [NSString stringWithFormat:@"%f", coordinate.longitude], title, description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeString]];
}

- (void)showInGoogleMap:(CLLocationCoordinate2D)coordinate title:(NSString *)title description:(NSString *)description {
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DisplayName"];
    NSString *urlScheme = APP_SCHEME_URL;
    NSString *routeString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeString]];
}

#pragma mark - Getter/Setter
-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableDictionary *)maps {
    if (!_maps) {
        _maps = [NSMutableDictionary dictionary];
        
        [_maps setObject:kiOSUrl forKey:@"苹果地图"];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kGaodeUrl]]) {
            [_maps setObject:kGaodeUrl forKey:@"高德地图"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kBaiduUrl]]) {
            [_maps setObject:kBaiduUrl forKey:@"百度地图"];
        }
    }

    
    
    return _maps;
}



@end
