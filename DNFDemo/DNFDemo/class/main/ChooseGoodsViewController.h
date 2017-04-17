//
//  ChooseGoodsViewController.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/13.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface ChooseGoodsViewController : UIViewController

@property (nonatomic, copy) void(^chooseBack)(GoodsModel *model);
@end
