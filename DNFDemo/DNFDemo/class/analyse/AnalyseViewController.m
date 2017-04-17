//
//  AnalyseViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/17.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "AnalyseViewController.h"

@interface AnalyseViewController ()

@end

@implementation AnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"情况分析";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分析" image:nil tag:2];

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
