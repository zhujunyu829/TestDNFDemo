//
//  SalseViewController.m
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/17.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#import "SalseViewController.h"
#import "Masonry.h"
#import "ChooseGoodsViewController.h"
#import "SaleAndBuyModel.h"
#import "DBManger+BuyAndSale.h"
#import "GoodsModel.h"
@interface SalseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    UITextField *_inputField;
    UITextField *_priceField;
    long long _goodID;
    UITapGestureRecognizer *_tapKeyboard;

}
@end

@implementation SalseViewController
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
    self.navigationItem.title = @"买卖记录";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cofingNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardDidHideNotification object:nil];
    
}
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
        make.right.offset(-120);
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
        make.width.equalTo(@(40));
        make.right.offset(-10);
        make.height.mas_equalTo(40);
    }];
    [saveBtn addTarget:self action:@selector(saleAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"卖" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor grayColor]];
    
    UIButton *saleBtn = [UIButton new];
    [self.view addSubview:saleBtn];
    [saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceField.mas_top);
        make.width.equalTo(@(40));
        make.right.equalTo(saveBtn.mas_left).offset(-5);
        make.height.mas_equalTo(40);
    }];
    [saleBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [saleBtn setTitle:@"买" forState:UIControlStateNormal];
    [saleBtn setBackgroundColor:[UIColor grayColor]];
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
- (void)chooseAction:(id)sender{
    ChooseGoodsViewController *ctr = [ChooseGoodsViewController new];
    ctr.chooseBack = ^(GoodsModel *model) {
        [self getDataWithGoods:model];
    };
    [self.navigationController pushViewController:ctr animated:YES];
}
- (void)saleAction:(id) sender{
    SaleAndBuyModel *recordModel = [SaleAndBuyModel new];
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    recordModel.saleTime = [f stringFromDate:[NSDate date]];
    recordModel.salePrice = [_priceField.text floatValue];
    [self saveWithModel:recordModel];
}
- (void)buyAction:(id) sender{
    SaleAndBuyModel *recordModel = [SaleAndBuyModel new];
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    recordModel.buyTime = [f stringFromDate:[NSDate date]];
    recordModel.buyPrice = [_priceField.text floatValue];
    [self saveWithModel:recordModel];
}

- (void)saveWithModel:(SaleAndBuyModel*)recordModel{
    [self.view endEditing:YES];
    if ([_priceField.text floatValue] <=0) {
        return;
    }
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
    if (recordModel.salePrice) {
        [DBManger updateSaleWitModel:recordModel];
    }else{
        [DBManger creactBuyAndSaleWitModel:recordModel];

    }
    [self refreshData];
}


- (void)refreshData{
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:[DBManger getBuyAndSaleByGoodsId:_goodID]];
    [_tableView reloadData];
}

#pragma mark-request
- (void)getDataWithGoods:(GoodsModel *)goods {
    _goodID = goods.ID;
    _inputField.text = goods.name;
    [self refreshData];
    
}
#pragma mark-UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_dataArr count];//_dataArr.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SaleAndBuyModel  *model = _dataArr[indexPath.row];
    [DBManger deleteBuyAndSaleByID:model.ID];
    [_dataArr  removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    UILabel *priceLabel = [cell.contentView viewWithTag:1001];
    if (!priceLabel) {
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, DeviceWidth*0.4 , 44)];
        priceLabel.right =  cell.width -10;
        [cell.contentView addSubview:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.tag = 1001;
    }
    UILabel *buyLabel = [cell.contentView viewWithTag:1003];
    if (!buyLabel) {
        buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DeviceWidth*0.6, 44)];
        [cell.contentView addSubview:buyLabel];
        buyLabel.textAlignment = NSTextAlignmentLeft;
        buyLabel.tag = 1003;
    }
    UILabel *saleLabel = [cell.contentView viewWithTag:1002];
    if (!saleLabel) {
        saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, buyLabel.bottom, DeviceWidth*0.6, 44)];
        [cell.contentView addSubview:saleLabel];
        saleLabel.textAlignment = NSTextAlignmentLeft;
        saleLabel.tag = 1002;
    }
  
    SaleAndBuyModel *model = _dataArr[indexPath.row];
    
    buyLabel.text = [NSString stringWithFormat:@"买：%@",[NSString  moneyStringFormFloat:model.buyPrice]];
    if (model.salePrice) {
        saleLabel.textColor = buyLabel.textColor;
        saleLabel.text =[NSString stringWithFormat:@"卖：%@", [NSString  moneyStringFormFloat:model.salePrice]];
        priceLabel.text = [NSString moneyStringFormFloat:(model.salePrice*0.97-model.buyPrice)];
    }else{
        saleLabel.text =[NSString stringWithFormat:@"卖：%@", [NSString moneyStringFormFloat:(model.buyPrice/0.97)]];
        saleLabel.textColor = ColorHex(@"757575");
        priceLabel.text = @"0";
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _priceField) {
    }
    return YES;
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
