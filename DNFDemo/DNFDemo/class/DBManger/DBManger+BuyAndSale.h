//
//  DBManger+BuyAndSale.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/26.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger.h"

@class SaleAndBuyModel;

@interface DBManger (BuyAndSale)

+ (NSArray *)getBuyAndSaleByGoodsId:(long long)goodsID;

+ (BOOL) creactBuyAndSaleWitModel:(SaleAndBuyModel *)model;

+ (BOOL)updateSaleWitModel:(SaleAndBuyModel *)model;

+ (BOOL) deleteBuyAndSaleByID:(long long)ID;

@end
