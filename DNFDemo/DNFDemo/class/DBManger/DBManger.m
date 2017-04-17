//
//  DBManger.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger.h"
@implementation DBManger

+ (id)shareManger{
    static DBManger *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DBManger alloc] init];
    });
    return manger;
}

+ (void)cheakDB{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        [self updateDB_1_0:db];
        
        [db close];
    }
}

/**
 1.0数据库更新

 @param db 数据库
 */
+ (void)updateDB_1_0:(FMDatabase *)db{
    [self createTable:db
                 name:@"t_service"
       WithDictionary:@{@"name":@"varchar(200)"}
           primaryKey:@"id"];
    
    [self createTable:db
                 name:@"t_goods"
       WithDictionary:@{@"name":@"varchar(200)",
                        @"service_id":@"bigint",
                      }
           primaryKey:@"id"];
    
    [self createTable:db
                 name:@"t_goods_record"
       WithDictionary:@{
                        @"goods_id":@"bigint",
                        @"price":@"decimal",
                        @"time":@"datetime"}
           primaryKey:@"id"];
}

/**
 创建表
 @param tableName 表名称
 @param db 数据库
 @param dic 表字段字典 {@"字段名称":@"字段类型"}
 @param key 唯一标示字段
 */
+ (void)createTable:(FMDatabase *)db name:(NSString *)tableName WithDictionary:(NSDictionary *)dic primaryKey:(NSString *)key{
    NSMutableString *tableSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",tableName];
    if (key) {
        [tableSQL appendFormat:@"%@ bigint PRIMARY KEY NOT NULL,",key];
    }
    NSAssert(dic, @"表字段为空");
    for (NSString * name in [dic allKeys]) {
        [tableSQL appendFormat:@"%@ %@,",name,[dic objectForKey:name]];
    }
    [tableSQL deleteCharactersInRange:NSMakeRange(tableSQL.length-1, 1)];
    [tableSQL appendString:@")"];
    [db executeUpdate:tableSQL];
}

+ (void)addColumn:(NSString *)columnName type:(NSString *)type tableName:(NSString *)tableName WithDB:(FMDatabase *)db{
    if (![db columnExists:columnName inTableWithName:tableName]) {
        [db executeUpdate: [NSString stringWithFormat:@" alter table %@ add column %@ %@",tableName,columnName,type]];
    }
}

+ (void)addColumn:(NSString *)columnName type:(NSString *)type tableName:(NSString *)tableName defaultValue:(id)value WithDB:(FMDatabase *)db{
    if (![db columnExists:columnName inTableWithName:tableName]) {
        [db executeUpdate: [NSString stringWithFormat:@" alter table %@ add column %@ %@ default %@",tableName,columnName,type,value]];
    }
}
@end
