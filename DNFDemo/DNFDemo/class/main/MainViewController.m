//
//  MainViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/13.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"
#import "GoodsModel.h"
#import "GoodsRecordModel.h"
#import "DBManger.h"
#import "DBManger+main.h"
#import "ChooseGoodsViewController.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    UITextField *_inputField;
    UITextField *_priceField;
    long long _goodID;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigHeadView];
    [self cofigField];
    [self configTable];
    [self configArr];
    self.navigationItem.title = @"价格记录";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"趋势" image:nil tag:0];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UIHelper
- (void)configArr{
    _dataArr = [NSMutableArray new];
    NSArray *goodsArr = [DBManger getGoods];
    if (goodsArr.count) {
        [self getDataWithGoods:goodsArr[0]];
    }
}
- (void)configTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(_priceField.mas_bottom);
        make.bottom.offset(-50);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)cofigHeadView{
    UIButton *choseButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:choseButon];
    [choseButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(64);
        make.right.offset(-20);
        make.height.mas_equalTo(50);
    }];
    [choseButon setTitle:@"选择" forState:UIControlStateNormal];
    [choseButon addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    choseButon.backgroundColor = [UIColor grayColor];
}

- (void)cofigField{
    _inputField = [UITextField new];
    _inputField.delegate = self;
    [self.view addSubview:_inputField];
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.offset(120);
        make.right.offset(-10);
        make.height.mas_equalTo(40);
    }];
    _inputField.layer.masksToBounds = YES;
    _inputField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputField.layer.borderWidth = 0.5f;
    _inputField.placeholder = @"物品";
    
    _priceField = [UITextField new];
    _priceField.delegate = self;
    [self.view addSubview:_priceField];
    [_priceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.equalTo(_inputField.mas_bottom).offset(5);
        make.right.offset(-100);
        make.height.mas_equalTo(40);
    }];
    _priceField.placeholder = @"价格";
    _priceField.layer.masksToBounds = YES;
    _priceField.layer.borderColor = [UIColor grayColor].CGColor;
    _priceField.layer.borderWidth = 0.5f;

    UIButton *saveBtn = [UIButton new];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceField.mas_top);
        make.width.equalTo(@(80));
        make.right.offset(-10);
        make.height.mas_equalTo(40);
    }];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor grayColor]];
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
    GoodsRecordModel  *model = _dataArr[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@     %0.2f",model.time,model.price];
    cell.textLabel.text = string;
    return cell;
}
#pragma  mark-UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_inputField == textField) {
        _goodID = 0;
    }
}
#pragma mark-ButtonAction
- (void)saveAction:(id)sender{
    [self.view endEditing:YES];
    GoodsRecordModel *recordModel = [GoodsRecordModel new];

    if (!_goodID) {
        GoodsModel *model = [DBManger  searchGoodsWithName:_inputField.text ];
        if (!model) {
            model = [GoodsModel new];
            model.name = _inputField.text;
            [DBManger creactGoods:model];
        }
        GoodsModel *models = [DBManger  searchGoodsWithName:_inputField.text ];
        recordModel.goodsID = models.ID;
        _goodID = models.ID;
    }
    recordModel.goodsID = _goodID;
  
    recordModel.price = [_priceField.text floatValue];
    
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    recordModel.time = [f stringFromDate:[NSDate date]];
    [DBManger creactGoodRecord:recordModel];
    _priceField.text = nil;
    [self refreshData];
    
}
- (void)chooseAction:(id)sender{
    ChooseGoodsViewController *ctr = [ChooseGoodsViewController new];
    ctr.chooseBack = ^(GoodsModel *model) {
        [self getDataWithGoods:model];
    };
    [self.navigationController pushViewController:ctr animated:YES];
}
- (void)refreshData{
    [self getDataWithGoodsID:_goodID success:^{
        [_tableView reloadData];
    }];
}
#pragma mark-loadData
- (void)getDataWithGoods:(GoodsModel *)goods {
    _goodID = goods.ID;
    _inputField.text = goods.name;
   [self getDataWithGoodsID:_goodID success:^{
       [_tableView reloadData];
   }];
    
}

- (void)getDataWithGoodsID:(long long)goodID success:(voidBlock)success{
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:[DBManger getRecordByGoods:goodID]];
    success();
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
