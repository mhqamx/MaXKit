//
//  MXFormatterUtils.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/7/18.
//  Copyright © 2019 马霄. All rights reserved.
//

#pragma mark 常用正则
#define REGEX_INPUT_DECIMAL                 @"^[.0-9]+$"    //小数
#define REGEX_INPUT_INT                     @"^[0-9]+$"     //整数
#define REGEX_INPUT_STRING                  @"^[a-zA-Z]+$"  //字母
#define REGEX_INPUT_CHAR_NUMBER             @"^[0-9a-zA-Z]+$"  //字母
#define REGEX_INPUT_CHAR_ID_NUMBER          @"^[0-9+x+X]+$"  //身份证
#define REGEX_INPUT_UNSPECIAL_CHARACTERS    @"^[a-zA-Z0-9\u4e00-\u9fa5]+$"    //无特殊字符
#define REGEX_INPUT_CHINESE                 @"^[\u4e00-\u9fa5]+$"    //中文
#define REGEX_INPUT_DOUBLE_CHARACTERS       @"[^\x00-\xff]"   //双字节 中文、日文、全角等符号
#define REGEX_INPUT_EMAIL                   @"^[A-Z0-9a-z@._]"  //邮箱字符输入

#define REGEX_VERIFY_MOBILE                 @"^1+[345789]+\\d{9}" //手机号
#define REGEX_VERIFY_EMAIL                  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" //邮箱验证

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXFormatterUtils : NSObject

/**
 格式化字符串
 
 @param data 请求数据
 @return 字符串
 */
+ (NSString *)stringFormat:(NSString *)data;

/**
 获取字符串中满族指定表达式格式的内容
 
 @param regular 正则
 @param text 字符串
 @return 匹配到的内容
 */
+ (NSArray *)match:(NSString *)regular fromString:(NSString *)text;

/**
 将字符串分成两段
 
 @param string 字符串
 @param symbol 分隔符
 @return NSArray
 */
+ (NSArray *)splitString:(NSString *)string withSymbol:(NSString *)symbol;

/**
 判断字符串是否满足表达式
 
 @param regular 表达式
 @param text 字符串
 @return BOOL
 */
+ (BOOL)predicate:(NSString *)regular WithText:(NSString *)text;

/**
 金额格式化
 
 @param string 金额
 @return 带千分位的金额
 */
+ (NSString *)amountFormatter:(NSString *)string;



@end

NS_ASSUME_NONNULL_END
