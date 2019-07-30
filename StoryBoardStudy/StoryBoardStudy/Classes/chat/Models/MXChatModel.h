//
//  MXChatModel.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/18.
//  Copyright © 2018 马霄. All rights reserved.
//

#import "MXBaseModel.h"

@interface MXChatModel : MXBaseModel
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, copy) NSString *contentStr;
@end

@interface MXChatFrameModel : MXBaseModel
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) MXChatModel *chatModel;
@end
