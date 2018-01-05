//
//  DBManger+main.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger+main.h"
#import "GoodsModel.h"
#import "GoodsRecordModel.h"
#import "Model.h"
@implementation DBManger (main)


+ (NSArray *)getRecordByGoods:(long long)goodsID{
    NSMutableArray *arr = [NSMutableArray new];
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:[NSString stringWithFormat:@"SELECT  t.*,t1.name as goodname FROM   t_goods_record t left join t_goods t1  on t1.id= t.goods_id where t.goods_id=%lld order by t.time desc",goodsID]];
        while([resultSet next]) {
            GoodsRecordModel *model = [GoodsRecordModel new];
            model.ID = [[resultSet stringForColumn:@"id"] longLongValue];
            model.name = [resultSet stringForColumn:@"goodname"];
            model.price = [[resultSet stringForColumn:@"price"] floatValue];
            model.time = [resultSet stringForColumn:@"time"];
            [arr addObject:model];
        }
        [db close];
    }
    return arr;
}





+ (BOOL)creactGoodRecord:(GoodsRecordModel *)model{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"insert into t_goods_record (id, goods_id,price,time) values (%0.f,%lld,%f,'%@')",[[NSDate date] timeIntervalSince1970],model.goodsID,model.price,model.time]];
        [db close];
        return update;
    }
    return NO;
}
+ (BOOL)deleteRecordByRecordID:(long long)recordID{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"delete from t_goods_record  where id=%lld",recordID]];
        [db close];
        return update;
    }

    return NO;
}
@end
