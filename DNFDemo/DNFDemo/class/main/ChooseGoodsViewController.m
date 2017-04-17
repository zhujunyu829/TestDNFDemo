//
//  ChooseGoodsViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/13.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "ChooseGoodsViewController.h"
#import "GoodsModel.h"
#import "DBManger.h"
#import "DBManger+main.h"
#import "Masonry.h"

@interface ChooseGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation ChooseGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configArr];
    [self configTable];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-UIHelper
- (void)configArr{
    _dataArr = [[NSMutableArray alloc]initWithArray:[DBManger getGoods]];
}
- (void)configTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
#pragma mark-UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [_dataArr[indexPath.row] name];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chooseBack) {
        self.chooseBack(_dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
