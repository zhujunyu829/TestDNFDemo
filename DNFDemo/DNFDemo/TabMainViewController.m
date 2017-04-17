//
//  TabMainViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/17.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "TabMainViewController.h"
#import "MainViewController.h"
#import "AnalyseViewController.h"
#import "SalseViewController.h"
@interface TabMainViewController ()
{
    UITabBarController *_tab;

}
@end

@implementation TabMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  cofigTabBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UINavigationController *)configNavigationCtr:(UIViewController *)ctr{
    if (!ctr) {
        ctr = [UIViewController new];
    }
    return [[UINavigationController alloc] initWithRootViewController:ctr];
}
- (void)cofigTabBar{
    _tab = [[UITabBarController alloc] init];
    UINavigationController *mainCtr = [self configNavigationCtr:[MainViewController new]];
    UINavigationController *salseCtr = [self configNavigationCtr:[SalseViewController new]];
    UINavigationController *analyseCtr = [self configNavigationCtr:[AnalyseViewController new]];
    mainCtr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分析" image:nil tag:0];
    salseCtr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"倒卖" image:nil tag:1];
    analyseCtr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"趋势" image:nil tag:2];
    _tab.viewControllers = [NSArray arrayWithObjects:mainCtr,salseCtr,analyseCtr,nil];

    //_tab.tabBar.items = [NSArray arrayWithObjects:mainItem,salseItem,analyseItem, nil];
    [self.view addSubview:_tab.view];
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
