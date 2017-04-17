//
//  DBManger.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManger : NSObject

/**
 单利对象

 @return 返回数据库操作对象
 */
+ (id)shareManger;

/**
 数据库检查与更新
 */
+ (void)cheakDB;

@end
