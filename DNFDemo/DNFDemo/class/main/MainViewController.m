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
    NSMutableDictionary *_dic;
    UILabel *_priceLable;
    long long _goodID;
    UITapGestureRecognizer *_tapKeyboard;
}
@end

@implementation MainViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigHeadView];
    [self cofigField];
    [self configTable];
    [self configArr];
    [self cofingNoti];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UIHelper
- (void)cofingNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardDidHideNotification object:nil];

}
- (void)configArr{
    _dataArr = [NSMutableArray new];
    if (self.model) {
        [self getDataWithGoods:self.model];
    }
//    NSArray *goodsArr = [DBManger getGoods];
//    if (goodsArr.count) {
//        [self getDataWithGoods:goodsArr[0]];
//    }
}
- (void)configTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(_priceLable.mas_bottom);
        make.bottom.offset(-50);
    }];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)cofigHeadView{
    UIButton *choseButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:choseButon];
    [choseButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.top.offset(64);
        make.right.offset(-20);
        make.height.mas_equalTo(40);
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
        make.top.offset(64);
        make.right.offset(-110);
        make.height.mas_equalTo(40);
    }];
    _inputField.layer.masksToBounds = YES;
    _inputField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputField.layer.borderWidth = 0.5f;
    _inputField.placeholder = @"物品";
    
    _priceField = [UITextField new];
    _priceField.delegate = self;
    _priceField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    _priceLable = [UILabel new];
    [self.view addSubview:_priceLable];
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceField.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    _priceLable.adjustsFontSizeToFitWidth = YES;
    _priceLable.textColor = [UIColor grayColor];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[_dic objectForKey:_dataArr[section]] count];//_dataArr.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = [_dic objectForKey:_dataArr[indexPath.section]];
    GoodsRecordModel  *model = arr[indexPath.row];
    [DBManger deleteRecordByRecordID:model.ID];
    [arr  removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    UILabel *priceLabel = [cell.contentView viewWithTag:1001];
    if (!priceLabel) {
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        priceLabel.right =  cell.width -10;
        [cell.contentView addSubview:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.tag = 1001;
    }
    NSArray *arr = [_dic objectForKey:_dataArr[indexPath.section]];
    GoodsRecordModel  *model = arr[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",[model.time substringFromIndex:11]];
    priceLabel.text = [NSString  moneyStringFormFloat:model.price];
    cell.textLabel.text = string;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    titleLabel.text = [[_dataArr objectAtIndex:section] substringToIndex:10];
    titleLabel.backgroundColor =  ColorHex(@"e5e5e5");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

#pragma  mark-UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_inputField == textField) {
        _goodID = 0;
        _priceLable.text = [NSString stringWithFormat:@"%0.2f",[_priceField.text  floatValue]/0.97];
//        textField.text = [NSString moneyStringFormFloat:[textField.text floatValue]];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _priceField) {
        _priceLable.text = [NSString stringWithFormat:@"%0.2f",[[_priceField.text stringByReplacingCharactersInRange:range withString:string]  floatValue]/0.97];
    }
    return YES;
}
#pragma mark-ButtonAction
- (void)keyboardShow:(UITextField*)sender{
    if (!_tapKeyboard) {
        _tapKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBoardAction:)];
    }
    [self.view addGestureRecognizer:_tapKeyboard];
}

- (void)keyboardDismiss:(UITextField *)sender{
    [self.view removeGestureRecognizer:_tapKeyboard];
}
- (void)tapBoardAction:(id) sender{
    [self.view endEditing:YES];
}
- (void)saveAction:(id)sender{
    [self.view endEditing:YES];
    if ([_priceField.text floatValue] <=0) {
        return;
    }
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
    
    _dic = [NSMutableDictionary new];
    NSMutableArray *arr = [NSMutableArray new];
    NSString *key  = nil;
    for (Model *model in _dataArr ) {
        if (!model.time || model.time.length <10) {
            continue;
        }
        if (!key) {
            key = [model.time substringToIndex:10];
        }
        if (![key isEqualToString:[model.time substringToIndex:10]]) {
            if (arr.count) {
                [_dic setObject:arr forKey:key];
            }
            arr = [NSMutableArray new];
            key = [model.time substringToIndex:10];
        }
        [arr addObject:model];
    }
    if (arr.count) {
        [_dic setObject:arr forKey:key];
    }
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:[_dic allKeys]];
   [_dataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      return  [obj2 compare:obj1];
       
   }];
    NSLog(@"%@",_dic);
    
    
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
