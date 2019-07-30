//
//  MXBaseModel.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXBaseModel : JSONModel
/**
 初始化
 
 @param data NSDictionary
 @return self
 */
- (instancetype)initWithData:(NSDictionary *)data;

/**
 转化成字典
 
 @return self
 */
- (NSMutableDictionary *)toDictionary;

/**
 对象转json字符串
 
 @return self
 */
- (NSString *)toJson;
@end

NS_ASSUME_NONNULL_END
