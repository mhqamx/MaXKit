//
//  MXViewT.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULTCELLHEIGHT 44.f

NS_ASSUME_NONNULL_BEGIN

typedef void (^clickBlock)(NSInteger index);

@interface MXViewT : UIView

+ (instancetype)defaultView;

@property (nonatomic, copy) clickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
