//
//  DBManger.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger.h"
#import "GoodsModel.h"

@implementation DBManger

+ (NSArray *)getGoods{
    NSMutableArray *arr = [NSMutableArray new];
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:@"SELECT  t.*, (select avg(t1.price) from  t_goods_record t1 where t1.goods_id = t.id)as avg FROM t_goods t "];
        while([resultSet next]) {
            GoodsModel *model = [GoodsModel new];
            model.ID = [[resultSet stringForColumn:@"id"] longLongValue];
            model.name = [resultSet stringForColumn:@"name"];
            model.average = [[resultSet stringForColumn:@"avg"] floatValue];
            [arr addObject:model];
        }
        [db close];
    }
    return arr;
}

+ (GoodsModel *)searchGoodsWithName:(NSString *)name{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:[NSString stringWithFormat:@"SELECT  *FROM t_goods where name='%@'",name]];
        GoodsModel *model ;
        
        if ([resultSet next]) {
            model = [GoodsModel new];
            model.ID = [[resultSet stringForColumn:@"id"] longLongValue];
            model.name = [resultSet stringForColumn:@"name"];
        }
        [db close];
        return model;
    }
    return nil;
}
+ (BOOL)creactGoods:(GoodsModel *)model{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:[NSString stringWithFormat:@"SELECT  *FROM t_goods where name='%@'",model.name]];
        if ([resultSet next]) {
            [db close];
            return YES;
        }
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"insert into t_goods (id, name) values (%0.f,'%@')",[[NSDate date] timeIntervalSince1970],model.name]];
        
        [db close];
        return update;
    }
    return NO;
}

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
    [self createTable:db
                 name:@"t_buy_sale"
       WithDictionary:@{
                        @"goods_id":@"bigint",
                        @"buy_price":@"decimal",
                        @"buy_time":@"datetime",
                        @"sale_price":@"decimal",
                        @"sale_time":@"datetime"}
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
