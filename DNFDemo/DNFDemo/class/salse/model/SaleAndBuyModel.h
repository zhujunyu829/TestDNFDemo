//
//  SaleAndBuyModel.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/26.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "Model.h"

@interface SaleAndBuyModel : Model

@property (nonatomic, assign) long long goodsID;
@property (nonatomic, assign) float buyPrice;
@property (nonatomic, assign) float salePrice;
@property (nonatomic, copy) NSString *buyTime;
@property (nonatomic, copy) NSString *saleTime;


@end
