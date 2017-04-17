//
//  SalseViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/17.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "SalseViewController.h"

@interface SalseViewController ()

@end

@implementation SalseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"买卖记录";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"倒卖" image:nil tag:1];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
