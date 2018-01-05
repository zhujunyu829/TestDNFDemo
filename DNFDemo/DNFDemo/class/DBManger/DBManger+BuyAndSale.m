//
//  DBManger+BuyAndSale.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/26.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger+BuyAndSale.h"
#import "SaleAndBuyModel.h"
@implementation DBManger (BuyAndSale)

+ (NSArray *)getBuyAndSaleByGoodsId:(long long)goodsID{
    NSMutableArray *arr = [NSMutableArray new];
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:[NSString stringWithFormat:@"SELECT  t.*,t1.name as goodname FROM   t_buy_sale t left join t_goods t1  on t1.id= t.goods_id where t.goods_id=%lld order by t.sale_price desc",goodsID]];
        while([resultSet next]) {
            SaleAndBuyModel *model = [SaleAndBuyModel new];
            model.ID = [[resultSet stringForColumn:@"id"] longLongValue];
            model.name = [resultSet stringForColumn:@"goodname"];
            model.buyPrice = [[resultSet stringForColumn:@"buy_price"] floatValue];
            model.buyTime = [resultSet stringForColumn:@"buy_time"];
            model.saleTime =  [resultSet stringForColumn:@"sale_time"];
            model.salePrice =  [[resultSet stringForColumn:@"sale_price"] floatValue];
            model.goodsID = goodsID;
            [arr addObject:model];
        }
        [db close];
    }

    return arr;
}

+ (BOOL) creactBuyAndSaleWitModel:(SaleAndBuyModel *)model{
    
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"insert into t_buy_sale (id, goods_id,buy_price,sale_price,buy_time,sale_time) values (%0.f,%lld,%f,%f,'%@','%@')",[[NSDate date] timeIntervalSince1970],model.goodsID,model.buyPrice,model.salePrice,model.buyTime,model.saleTime]];
        [db close];
        return update;
    }
    return NO;
}
+ (BOOL)updateSaleWitModel:(SaleAndBuyModel *)model{
    
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        FMResultSet *resultSet =   [db executeQuery:[NSString stringWithFormat:@"SELECT id from t_buy_sale where goods_id =%lld and  sale_price =0 order by buy_price asc",model.goodsID]];
        long long ID ;
        if ([resultSet next]) {
            ID = [[resultSet stringForColumn:@"id"] longLongValue];
        }else{
            NSLog(@"没有");
            [db close];
            return NO;
        }
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"update t_buy_sale set sale_price=%f,sale_time='%@' where id=%lld ",model.salePrice,model.saleTime,ID]];
        [db close];
        return update;
    }
    
    return NO;
}
+ (BOOL) deleteBuyAndSaleByID:(long long)ID{
    FMDatabase *db = [FMDatabase databaseWithPath:APPDBPATH];
    if ([db open]) {
        BOOL update = [db executeUpdate:[NSString stringWithFormat:@"delete from t_buy_sale  where id=%lld",ID]];
        [db close];
        return update;
    }
    return NO;
}
@end
