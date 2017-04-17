//
//  DBManger+main.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger.h"

@class GoodsModel;
@class GoodsRecordModel;
@interface DBManger (main)


+ (NSArray *)getGoods;

+ (GoodsModel *)searchGoodsWithName:(NSString *)name;

+ (NSArray *)getRecordByGoods:(long long)goodsID;

+ (BOOL)creactGoods:(GoodsModel *)model;

+ (BOOL)creactGoodRecord:(GoodsRecordModel *)model;

+ (GoodsModel *)searchGoodsWithName:(NSString *)name;
@end
