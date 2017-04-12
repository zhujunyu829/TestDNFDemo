//
//  DBManger.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "DBManger.h"
#import "FMDB.h"
@implementation DBManger

+ (id)shareManger{
    static DBManger *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DBManger alloc] init];
    });
    return manger;
}

- (void)cheakDB{
    
}

@end
