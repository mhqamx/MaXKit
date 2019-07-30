//
//  MXLoginModel.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXLoginModel : MXBaseModel
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *age;
@property (nonatomic, strong) NSString <Optional> *gender;
@property (nonatomic, strong) NSString <Optional> *userName;
@property (nonatomic, strong) NSString <Optional> *passWord;
@end

NS_ASSUME_NONNULL_END
