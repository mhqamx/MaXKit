//
//  MXSQLite.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/8/21.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXSQLiteDataModel : NSObject
/**
 主键、自增型
 */
@property (strong, nonatomic) NSNumber *pid;

@end

@interface MXSQLite : NSObject

/**
 单例 (默认数据库名为 [NSBundle mainBundle].bundleIdentifier.sqlite)
 
 @return SWSQLite
 */
+ (instancetype)sharedDatabase;
+ (instancetype)sharedDatabaseWithName:(NSString *)dbName;

/**
 创建表
 
 @param cls 类对象
 @return 结果 yes/no
 */
+ (BOOL)createTableWithClass:(Class)cls;

/**
 修改表结构
 
 @param cls 类对象
 @return 结果 yes/no
 */
+ (BOOL)alterTableWithClass:(Class)cls;

/**
 删除表
 
 @param cls 类对象
 @return 结果 yes/no
 */
+ (BOOL)deleteTableWithClass:(Class)cls;

/**
 插入单条表数据
 
 @param obj 类对象
 @return 结果 yes/no
 */
+ (BOOL)tableInsertWithObject:(id)obj;

/**
 批量插入(添加事务处理)
 
 @param array 对象集合
 @return 结果 yes/no
 */
+ (BOOL)tableInsertWithArray:(NSArray *)array;

/**
 根据主键PID删除
 
 @param obj 对象
 @return 结果 yes/no
 */
+ (BOOL)tableDeleteByPrimaryKey:(id)obj;

/**
 清空表
 
 @param cls 类对象
 @return 结果 yes/no
 */
+ (BOOL)tableDeleteAllWithClass:(Class)cls;

/**
 更新表数据（根据主键）
 
 @param obj 类对象
 @param params 条件语句(如：@[@"name", "age",....])若此参数为空则默认根据主键pid更新
 @return 结果 yes/no
 */
+ (BOOL)tableUpdateWithObject:(id)obj whereParams:(NSArray *)params;


/**
 根据指定检索语句进行更新
 
 @param array 数据列表
 @param params 条件语句(如：@[@"name", "age",....])若此参数为空则默认根据主键pid更新
 @return yes/no
 */
+ (BOOL)tableUpdateWithArray:(NSArray *)array whereParams:(NSArray *)params;

/**
 查询
 
 @param sql sql语句
 @param cls 类对象
 @return 结果 yes/no
 */
+ (NSArray *)tableQueryWithSQL:(NSString *)sql destClass:(Class)cls;

/**
 查询所有数据
 
 @param cls 类对象
 @return 结果 yes/no
 */
+ (NSArray *)tableQueryAllDataWithClass:(Class)cls;

+ (NSDictionary *)toDictionary:(id)obj;
@end

NS_ASSUME_NONNULL_END
