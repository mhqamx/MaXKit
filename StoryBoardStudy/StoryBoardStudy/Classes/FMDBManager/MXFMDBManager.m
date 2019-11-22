//
//  MXFMDBManager.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/16.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXFMDBManager.h"
#import <objc/runtime.h>

@interface MXFMDBManager()

/**
 数据库操作句柄
 */
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation MXFMDBManager
#pragma mark - Public
+ (instancetype)manager {
    static MXFMDBManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXFMDBManager alloc] init];
    });
    return manager;
}

#pragma mark - 建表
- (void)creatTableWithModel:(__unsafe_unretained Class)cls {
    u_int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREAT TABLE IF NOT EXISTS %@ (MID INTEGER PRIMARY KEY AUTOINCERMENT)", [NSString stringWithFormat:@"%@", [NSStringFromClass(cls) uppercaseString]]];
    NSString *colName = @"";
    for (int i = 0; i < count; i++) {
        colName = [[NSString stringWithUTF8String:property_getName(properties[i])] uppercaseString];
        if ([@"MID" isEqualToString:colName]) continue;
        
        if (i + 1 == count) {
            [sql appendString:[NSString stringWithFormat:@", %@ TEXT", colName]];
        } else {
            [sql appendString:[NSString stringWithFormat:@", %@ TEXT", colName]];
        }
    }
    [self execute:sql];
}

#pragma mark - 创建唯一索引
- (void)creatUniqueIndex:(NSArray *)colNames clas:(Class)cls {
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE UNIQUE INDEX `%@_UNIQUE` ON `%@` (", [NSStringFromClass(cls) uppercaseString], [NSStringFromClass(cls) uppercaseString]];
    int i=0;
    for (NSString *colName in colNames) {
        
        if (i+1<colNames.count && colNames.count > 1) {
            
            [sql appendFormat:@"'%@', ", [colName uppercaseString]];
        }else{
            [sql appendFormat:@"'%@')", [colName uppercaseString]];
        }
        i++;
    }
    [self execute:sql];
}

#pragma mark - Private
- (instancetype)init {
    
    if (self = [super init]) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                          firstObject];
        NSString *dbname = [NSString stringWithFormat:@"%@.db", [[NSBundle mainBundle] bundleIdentifier]];
        _database = [FMDatabase databaseWithPath:[path stringByAppendingPathComponent:dbname]];
    }
    return self;
}

#pragma mark 通用执行语句
- (BOOL)execute:(NSString *)sql, ...{
    
    va_list args;
    va_start(args, sql);
    
    BOOL result = NO;
    if ([_database open]) {
        
        NSLog(@"EXECUTE SQL:【%@】", sql);
        result = [_database executeUpdate:sql withVAList:args];
        
        if (!result) {
            
            NSLog(@"EXECUTE SQL:【%@】 FAILURE \n ERROR CODE:【%d】 \n ERROR MESSAGE:【%@】",
                  sql, [_database lastErrorCode], [_database lastErrorMessage]);
        }
        
        va_end(args);
    }
    
    return result;
}

- (BOOL)excuteBatch:(NSArray<NSString *> *)sqls {
    
    BOOL result = YES;
    if ([_database open]) {
        
        BOOL rollback = NO;
        [_database beginTransaction];
        @try{
            
            for (NSString *sql in sqls) {
                
                if (sql.length > 0) {
                    
                    [_database executeUpdate:sql];
                }
            }
        }
        @catch (NSException *exeption) {
            
            result = NO;
            rollback = YES;
            [_database rollback];
            NSLog(@"exception:%@", exeption);
        }
        @finally {
            
            if (!rollback) {
                NSLog(@"批量操作成功，影响行数%ld", sqls.count);
                [_database commit];
            }
        }
        
    }else{
        result = NO;
    }
    
    return result;
}

#pragma mark 通用查询语句
- (FMResultSet *)executeQuery:(NSString *)sql, ... {
    
    va_list args;
    va_start(args, sql);
    FMResultSet *set;
    
    if ([_database open]) {
        
        set = [_database executeQuery:sql withVAList:args];
        if ([_database lastErrorCode]) {
            
            NSLog(@"executeQuery failed：%d, %@",[_database lastErrorCode], [_database lastErrorMessage]);
        }
        
        va_end(args);
    }
    
    return set;
}

#pragma mark 关闭链接
+ (void)closeDB {
    
    if ([[MXFMDBManager manager].database open]) {
        
        [[MXFMDBManager manager].database close];
    }
}

@end
