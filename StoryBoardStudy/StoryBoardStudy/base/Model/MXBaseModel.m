//
//  MXBaseModel.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXBaseModel.h"

@implementation MXBaseModel

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    return [NSMutableDictionary dictionary];
}

- (NSString *)toJson {
    NSError  *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error || !jsonData) {
        NSLog(@"%@ to json string failed!!!", NSStringFromClass([self class]));
        return @"";
    }else
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
