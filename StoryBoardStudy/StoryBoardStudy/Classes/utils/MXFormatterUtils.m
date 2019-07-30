//
//  MXFormatterUtils.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/7/18.
//  Copyright © 2019 马霄. All rights reserved.
//  字符串格式化

#import "MXFormatterUtils.h"

@implementation MXFormatterUtils

+ (NSString *)stringFormat:(NSString *)data {
    
    return data ? data:@"";
}

+ (NSArray *)match:(NSString *)regular fromString:(NSString *)text{
    
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:regular options:0 error:&error];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    // 2.遍历结果
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        
        // 将结构体保存到数组
        // 先用一个变量接受结构体
        NSRange range = result.range;
        NSValue *value = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
        [ranges addObject:value];
    }
    
    return ranges;
}

+ (NSArray *)splitString:(NSString *)string withSymbol:(NSString *)symbol {
    
    NSRange range = [string rangeOfString:symbol];
    if (range.location == NSNotFound) {
        return @[string];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    [array addObject:[NSValue valueWithRange:NSMakeRange(0, range.location)]];
    [array addObject:[NSValue valueWithRange:NSMakeRange(range.location, range.length)]];
    return array;
}

+ (BOOL)predicate:(NSString *)regular WithText:(NSString *)text {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [predicate evaluateWithObject:text];
}

+ (NSString *)amountFormatter:(NSString*)string
{
    if (string.length == 0) {
        return @"";
    }
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *numFormatter2 = [[NSNumberFormatter alloc] init];
    [numFormatter2 setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *num = [numFormatter2 numberFromString:string];
    NSString *tempStr = [numFormatter stringFromNumber:num];
    NSString *balanceStr = [tempStr substringFromIndex:1];
    if ([tempStr hasPrefix:@"-"]) {
        balanceStr = [NSString stringWithFormat:@"-%@",[tempStr substringFromIndex:2]];
    }
    return balanceStr;
}



@end
