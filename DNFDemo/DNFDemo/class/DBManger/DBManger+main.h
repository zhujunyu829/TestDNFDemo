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


+ (NSArray *)getRecordByGoods:(long long)goodsID;

+ (BOOL)creactGoodRecord:(GoodsRecordModel *)model;

+ (BOOL)deleteRecordByRecordID:(long long)recordID;
@end
