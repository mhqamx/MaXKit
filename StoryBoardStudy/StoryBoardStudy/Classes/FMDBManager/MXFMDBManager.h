//
//  MXFMDBManager.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/4/16.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface MXFMDBManager : NSObject

/**
 单例
 
 @return self
 */
+ (instancetype)manager;

/**
 关闭链接
 */
+ (void)closeDB;

/**
 建表
 
 @param cls 表对象
 */
- (void)creatTableWithModel:(__unsafe_unretained Class)cls;

/**
 创建唯一索引
 
 @param colNames 列名
 @param cls 表模型
 */
- (void)creatUniqueIndex:(NSArray *)colNames clas:(Class)cls;

/**
 查询
 
 @param sql sql语句
 @return 列表
 */
- (FMResultSet *)executeQuery:(NSString *)sql, ...;

/**
 执行sql语句
 
 @param sql sql语句
 @return 执行结果
 */
- (BOOL)execute:(NSString *)sql,...;

/**
 批量操作
 
 @param sqls sql列表
 @return 执行结果
 */
- (BOOL)executeBatch:(NSArray<NSString *> *)sqls;






@end

