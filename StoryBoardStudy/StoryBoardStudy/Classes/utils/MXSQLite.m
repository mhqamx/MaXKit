//
//  MXSQLite.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/8/21.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXSQLite.h"

#import <objc/runtime.h>
#import <FMDB/FMDB.h>

FOUNDATION_EXPORT NSExceptionName const NSOpenDatabaseException;
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

// 数据库中常见的几种类型
#define SQL_TEXT     @"TEXT" //文本
#define SQL_INTEGER  @"INTEGER" //int long integer ...
#define SQL_REAL     @"REAL" //浮点
#define SQL_BLOB     @"BLOB" //data

@implementation MXSQLiteDataModel

@end

@interface MXSQLite () {
    NSExceptionName NSOpenDatabaseException;
    NSString * _dbName;
}

@property (strong, nonatomic) FMDatabase *database;

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation MXSQLite

#pragma mark  - Public
+ (instancetype)sharedDatabase {
    return [MXSQLite sharedDatabaseWithName:@""];
}

+ (instancetype)sharedDatabaseWithName:(NSString *)dbName {
    static MXSQLite *database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[MXSQLite alloc] initWithDBName:dbName];
    });
    return database;
}

+ (BOOL)createTableWithClass:(Class)cls {
    NSString *tableName = NSStringFromClass(cls);
    NSDictionary *props = getAllProperties(cls, NO);
    NSArray *colNames = props.allKeys;
    
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (pid INTEGER PRIMARY KEY AUTOINCREMENT", tableName];
    for (int i=0; i<colNames.count; i++) {
        [sql appendFormat:@", %@ %@",colNames[i], [props objectForKey:colNames[i]]];
    }
    [sql appendString:@")"];
    
    if ([[MXSQLite sharedDatabase] connect]) {
        BOOL ret = [[MXSQLite sharedDatabase] safetyExecuteUpdate:sql];
        [[MXSQLite sharedDatabase] disconnect];
        return ret;
    }else {
        return NO;
    }
}

+ (BOOL)alterTableWithClass:(Class)cls {
    NSDictionary *props = getAllProperties(cls, NO);
    NSString *tableName = NSStringFromClass(cls);
    NSDictionary *currentProps = getPropertiesByTableName(tableName);
    if (!currentProps || currentProps.allKeys.count == 0) {
        return NO;
    }
    
    if (![[MXSQLite sharedDatabase] connect]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    __block NSString *sql = @"";
    [[MXSQLite sharedDatabase] inTransactionWithCompletedBlock:^(BOOL *rollback) {
        for (NSString *colName in props.allKeys) {
            if ([currentProps.allKeys containsObject:colName]) {
                //当前库表中包含此属性
                continue;
            }
            sql = [NSString stringWithFormat: @"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, colName, props[colName]];
            ret = [[MXSQLite sharedDatabase] safetyExecuteUpdate:sql];
            if (!ret) {
                *rollback = YES;
                return ;
            }
        }
    }];
    [[MXSQLite sharedDatabase] disconnect];
    return ret;
}

+ (BOOL)deleteTableWithClass:(Class)cls {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", NSStringFromClass(cls)];
    if ([[MXSQLite sharedDatabase] connect]) {
        BOOL ret = [[MXSQLite sharedDatabase] safetyExecuteUpdate:sql];
        [[MXSQLite sharedDatabase] disconnect];
        return ret;
    }else {
        return NO;
    }
}

+ (BOOL)tableInsertWithObject:(id)obj {
    if (![[MXSQLite sharedDatabase] connect]) {
        return NO;
    }
    
    BOOL ret = [[MXSQLite sharedDatabase] tableInsertWithObject:obj];
    [[MXSQLite sharedDatabase] disconnect];
    return ret;
}

+ (BOOL)tableInsertWithArray:(NSArray *)array {
    if (array.count == 0) {
        return NO;
    }
    
    if (![[MXSQLite sharedDatabase] connect]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [[MXSQLite sharedDatabase] inTransactionWithCompletedBlock:^(BOOL *rollback) {
        for (id obj in array) {
            ret = [[MXSQLite sharedDatabase] tableInsertWithObject:obj];
            if (!ret) {
                *rollback = YES;
                break;
            }
        }
    }];
    [[MXSQLite sharedDatabase] disconnect];
    return ret;
}

+ (BOOL)tableDeleteByPrimaryKey:(id)obj {
    NSString *className = NSStringFromClass([obj class]);
    NSDictionary *props = objectToDictionary(obj);
    NSNumber *pk = [props objectForKey:@"pid"];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE PID=%@", className, pk];
    if ([[MXSQLite sharedDatabase] connect]) {
        BOOL ret = [[MXSQLite sharedDatabase] safetyExecuteUpdate:sql];
        [[MXSQLite sharedDatabase] disconnect];
        return ret;
    }else{
        return NO;
    }
}

+ (BOOL)tableDeleteAllWithClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", className];
    if ([[MXSQLite sharedDatabase] connect]) {
        BOOL ret = [[MXSQLite sharedDatabase] safetyExecuteUpdate:sql];
        [[MXSQLite sharedDatabase] disconnect];
        return ret;
    }else{
        return NO;
    }
}

+ (BOOL)tableUpdateWithObject:(id)obj whereParams:(NSArray *)params {
    if (!obj) {
        return NO;
    }
    if ([[MXSQLite sharedDatabase] connect]) {
        BOOL ret = [[MXSQLite sharedDatabase] tableUpdateWithObject:obj whereParams:params];
        [[MXSQLite sharedDatabase] disconnect];
        return ret;
    }else{
        return NO;
    }
}

+ (BOOL)tableUpdateWithArray:(NSArray *)array whereParams:(NSArray *)params {
    if (array.count == 0) {
        return NO;
    }
    
    if (![[MXSQLite sharedDatabase] connect]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [[MXSQLite sharedDatabase] inTransactionWithCompletedBlock:^(BOOL *rollback) {
        for (id obj in array) {
            ret = [[MXSQLite sharedDatabase] tableUpdateWithObject:obj whereParams:params];
            if (!ret) {
                *rollback = YES;
                break;
            }
        }
    }];
    [[MXSQLite sharedDatabase] disconnect];
    return ret;
}

+ (NSArray *)tableQueryWithSQL:(NSString *)sql destClass:(Class)cls {
    if (sql.length == 0) {
        return @[];
    }
    
    if (![[MXSQLite sharedDatabase] connect]) {
        return nil;
    }
    
    FMResultSet *rs = [[MXSQLite sharedDatabase] safetyExecuteQuery:sql];
    if (!rs) {
        return @[];
    }
    NSDictionary *props = getAllProperties(cls, YES);
    NSMutableArray *results = [NSMutableArray array];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:props.allKeys.count];
    id class = nil;
    id value = nil;
    while (rs.next) {
        for (NSString *colName in props.allKeys) {
            if ([props[colName] isEqualToString:SQL_BLOB]) {
                value = [rs dataForColumn:colName];
            }else if ([props[colName] isEqualToString:SQL_REAL]){
                value = [NSNumber numberWithDouble:[rs doubleForColumn:colName]];
            }else {
                value = [rs stringForColumn:colName];
                if (!value) {
                    value = @"";
                }
            }
            if (value) {
                [tempDict setObject:value forKey:colName];
            }
        }
        class = dictonaryToObject(cls, tempDict);
        if (class) {
            [results addObject:class];
        }
    }
    [[MXSQLite sharedDatabase] disconnect];
    return results;
}

+ (NSArray *)tableQueryAllDataWithClass:(Class)cls {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass(cls)];
    return [MXSQLite tableQueryWithSQL:sql destClass:cls];
}

#pragma mark  - Private
- (instancetype)initWithDBName:(NSString *)dbName {
    if (self = [super init]) {
        NSOpenDatabaseException = @"NSOpenDatabaseException";
        if (dbName.length == 0) {
            dbName = [[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"];
        }
        _dbName = [dbName copy];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[kDocumentPath stringByAppendingPathComponent:dbName]];
        _database = [_dbQueue valueForKey:@"_db"];
        if ([self connect]) {
            [self disconnect];
            return self;
        }
    }
    return nil;
}

- (BOOL)connect {
    if (self.database.isOpen) {
        return YES;
    }
    
    BOOL result = NO;
    @try {
        result = [self.database open];
    } @catch (NSException *exception) {
        NSLog(@"连接数据库【%@】失败:%@,%@", _dbName, exception.name, exception.reason);
    } @finally {
        return result;
    }
}

- (BOOL)disconnect {
    if (!self.database.isOpen) {
        return YES;
    }
    
    BOOL result = NO;
    @try {
        result = [self.database close];
    } @catch (NSException *exception) {
        NSLog(@"断开数据库【%@】连接失败:%@,%@", _dbName, exception.name, exception.reason);
    } @finally {
        return result;
    }
}

- (BOOL)tableInsertWithObject:(id)obj {
    NSString *tableName = NSStringFromClass([obj class]);
    NSDictionary *props = objectToDictionary(obj);
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *temp = [[NSMutableString alloc] initWithString:@") VALUES ("];
    NSArray *colNames = props.allKeys;
    id value;
    for (int i=0; i<colNames.count; i++) {
        value = [props objectForKey:colNames[i]];
        if (!value || [value isEqual:[NSNull null]] || ([value isKindOfClass:NSString.class] && [(NSString *)value length] == 0)) {
            value = NULL;
        }else {
            if ([value isKindOfClass:NSString.class]) {
                value = [NSString stringWithFormat:@"'%@'", value];
            }
        }
        if (i+1 == colNames.count) {
            [sql appendFormat:@"%@", colNames[i]];
            [temp appendFormat:@"%@)", value];
        }else{
            [sql appendFormat:@"%@, ", colNames[i]];
            [temp appendFormat:@"%@, ", value];
        }
    }
    [sql appendString:temp];
    return [self safetyExecuteUpdate:sql];
}

- (BOOL)tableUpdateWithObject:(id)obj whereParams:(NSArray *)params {
    NSString *tableName = NSStringFromClass([obj class]);
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET ", tableName];
    NSDictionary *props = objectToDictionary(obj);
    NSArray *colNames = props.allKeys;
    id value;
    for (int i=0; i<colNames.count; i++) {
        value = [props objectForKey:colNames[i]];
        if (!value || [value isEqual:[NSNull null]] || ([value isKindOfClass:NSString.class] && [(NSString *)value length] == 0)) {
            value = NULL;
        }else {
            if ([value isKindOfClass:NSString.class]) {
                value = [NSString stringWithFormat:@"'%@'", value];
            }
        }
        if (i+1 == colNames.count) {
            [sql appendFormat:@"%@ = %@", colNames[i], value];
        }else{
            [sql appendFormat:@"%@ = %@, ", colNames[i], value];
        }
    }
    
    NSMutableString *where = [[NSMutableString alloc] initWithString:@" WHERE "];
    if (params.count == 0) {
        [where appendFormat:@"pid = %@", [obj valueForKey:@"pid"]];
    }else {
        int i = 0;
        for (NSString *key in params) {
            if (i == 0) {
                [where appendFormat:@"%@ = %@", key, [obj valueForKey:key]];
            }else {
                [where appendFormat:@", %@ = %@", key, [obj valueForKey:key]];
            }
        }
    }
    [sql appendString:where];
    return [self safetyExecuteUpdate:sql];
}

- (BOOL)safetyExecuteUpdate:(NSString *)sql{
    BOOL ret = NO;
    @try {
        ret = [self.database executeUpdate:sql];
        NSLog(@"safetyExecuteUpdate :%@", sql);
    } @catch (NSException *exception) {
        NSLog(@"ExecuteUpdate 【%@】 Failed！！！\nReason:%@,%@", sql, exception.name, exception.reason);
    } @finally {
        return ret;
    }
}

- (FMResultSet *)safetyExecuteQuery:(NSString *)sql{
    FMResultSet *rs = nil;
    @try {
        rs = [self.database executeQuery:sql];
    } @catch (NSException *exception) {
        NSLog(@"ExecuteQuery 【%@】 Failed！！！\nReason:%@,%@", sql, exception.name, exception.reason);
    } @finally {
        return rs;
    }
}

- (void)inTransactionWithCompletedBlock:(void (^)(BOOL *rollback))completedBlock{
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        completedBlock(rollback);
    }];
}

- (void)inDatabaseWithCompletedBlock:(void (^)(void))completedBlock {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        completedBlock();
    }];
}

+ (NSDictionary *)toDictionary:(id)obj {
    return objectToDictionary(obj);
}

#pragma mark  根据表名获取属性列表及其对应类型
static NSDictionary *getPropertiesByTableName(NSString *tableName){
    if (![[MXSQLite sharedDatabase] connect]) {
        return nil;
    }
    FMResultSet *rs = [[MXSQLite sharedDatabase].database getTableSchema:tableName];
    if (!rs) {
        return nil;
    }
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    NSString *colName = @"";
    NSString *colType = @"";
    while (rs.next) {
        colName = [rs stringForColumn:@"name"];
        colType = [rs stringForColumn:@"type"];
        if (colName.length > 0 && colType.length > 0) {
            [props setObject:colType forKey:colName];
        }
    }
    return props;
}

#pragma mark  - Static
static NSDictionary *getProperties(Class cls){
    u_int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    NSMutableDictionary *props = [NSMutableDictionary dictionaryWithCapacity:count];
    NSString *colName = @"";
    NSString *colType = @"";
    for (int i=0; i<count; i++) {
        colName = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (colName.length == 0) {
            continue;
        }
        colType = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        colType = propertyTypeConvert(colType);
        if (colType.length > 0) {
            [props setObject:colType forKey:colName];
        }
    }
    free(properties);
    return props;
}

#pragma mark  根据类对象获取属性列表及其对应类型
static NSDictionary *getAllProperties(Class cls, BOOL returnPK) {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    BOOL ret = YES;
    Class supperCls = cls;
    while (ret) {
        NSDictionary *tempDict = getProperties(supperCls);
        for (NSString *key in tempDict.allKeys) {
            if ([key isEqualToString:@"pid"] && !returnPK) {
                continue;
            }
            [props setObject:[tempDict objectForKey:key] forKey:key];
        }
        if ([NSStringFromClass(supperCls) isEqualToString:NSStringFromClass(MXSQLiteDataModel.class)]) {
            ret = NO;
        }else {
            supperCls = class_getSuperclass(supperCls);
        }
    }
    return props;
}

#pragma mark  对象转字典
static NSDictionary *objectToDictionary(id obj){
    u_int count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    NSMutableDictionary *props = [NSMutableDictionary dictionaryWithCapacity:count];
    NSString *colName = @"";
    NSString *colType = @"";
    id value = @"";
    for (int i=0; i<count; i++) {
        colName = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (colName.length == 0 || [colName isEqualToString:@"pid"]) {
            continue;
        }
        colType = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        colType = propertyTypeConvert(colType);
        if (colType.length > 0) {
            value = [obj valueForKey:colName];
            if (!value) {
                value = [NSNull null];
            }
            [props setObject:value forKey:colName];
        }
    }
    free(properties);
    return props;
}

#pragma mark  字典转对象
static NSObject *dictonaryToObject(Class cls, NSDictionary *data){
    if (!data || data.allKeys.count == 0) {
        return nil;
    }
    
    id object = [[cls alloc] init];
    NSDictionary *props = getAllProperties(cls, YES);
    if (props.allKeys.count != data.allKeys.count) {
        return nil;
    }
    
    NSString *propName = @"";
    id value;
    for (int i=0; i<props.allKeys.count; i++) {
        propName = [props.allKeys objectAtIndex:i];
        if ([data.allKeys containsObject:propName]) {
            value = [data objectForKey:propName];
        }
        if (value) {
            [object setValue:value forKey:propName];
        }
    }
    return object;
}

static NSString *propertyTypeConvert(NSString *typeStr){
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }
    return resultStr;
}

@end
