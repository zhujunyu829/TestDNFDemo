//
//  GoodsRecordModel.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/13.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "Model.h"

@interface GoodsRecordModel : Model

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) long long goodsID;
@end
