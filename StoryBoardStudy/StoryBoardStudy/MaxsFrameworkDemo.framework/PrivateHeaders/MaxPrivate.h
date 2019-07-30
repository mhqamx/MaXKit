//
//  MaxPrivate.h
//  MaxsFrameworkDemo
//
//  Created by 马霄 on 2019/7/9.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol privateMethodDelegate <NSObject>

- (void)privateMethod;

@end


@interface MaxPrivate : NSObject

@property (assign, nonatomic) id <privateMethodDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
