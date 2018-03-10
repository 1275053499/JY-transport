//
//  JYSearchOrderViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYSearchOrderViewController.h"
#import "JYGrabTableViewCellThird.h"
#import "JYLooklogisticsTableViewCell.h"
#import "JYLookLogisticsTableViewCellSecond.h"
#import "JYLineTableViewCell.h"
#import "MineRequestData.h"
#import "JYTransportModel.h"
#import "JYOrderDetailModel.h"

#import "ScanViewController.h"
@interface JYSearchOrderViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MineRequestDataDelegate>
@property (nonatomic,strong)UIView *BottomView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *searchModelArr;
@property (nonatomic,strong)JYOrderDetailModel *detailModel;
@end

@implementation JYSearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_transportNumber == nil || _transportNumber.length <= 0) {
        _transportNumber = @"";

    }
    _searchModelArr = [NSArray array];
    [self createTableView];

    [self creatSearchBar];
}
- (void)creatSearchBar{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    _BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight - 80)];
    _BottomView.hidden = NO;
    [self.view addSubview:_BottomView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
    titleView.frame = CGRectMake(0, 26, ScreenWidth, 54);
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = RGB(238, 238, 238);
    textField.layer.cornerRadius = 15;
    textField.layer.masksToBounds = YES;
    textField.placeholder = @"请输入订单号";
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = RGB(51, 51, 51);
    textField.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    [titleView addSubview:textField];
    [self.view addSubview:titleView];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(50);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-54);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.height.mas_equalTo(30);
        
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_saoma_heise"] forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:BGBlue forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn addTarget:self action:@selector(scanCliBtnck:) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(textField.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(54);

        
    }];
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setImage:[UIImage imageNamed:@"PinLeftCopy"] forState:(UIControlStateNormal)];
    backbtn.backgroundColor = [UIColor whiteColor];
    [backbtn setTitleColor:BGBlue forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [backbtn addTarget:self action:@selector(backbtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:backbtn];
    
    [backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.centerY.mas_equalTo(textField.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        
        
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_wujieguo"];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有搜索结果";
    label.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    label.textColor = RGB(51, 51, 51);
    [_BottomView addSubview:imgView];
    [_BottomView addSubview:label];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_BottomView.mas_top).mas_offset(130);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).mas_offset(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
        
        
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [self queryGetTrackingByNumber];

    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;

}
- (void)backbtnClick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scanCliBtnck:(UIButton *)btn{
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    _transportNumber = textField.text;
    [textField resignFirstResponder];
    [self queryGetTrackingByNumber];

    return YES;
    
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,80, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;

}

- (void)chooseScanNumber:(NSString *)str{
    
    self.transportNumber = str;
    [self queryGetTrackingByNumber];
}
- (void)queryGetTrackingByNumber{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    manager.delegate = self;
    if (self.transportNumber.length <= 0 || self.transportNumber == nil || [self.transportNumber isEqual:[NSNull null]]) {
        
    }else {
        
        [manager requestGetTrackingByNumber:@"app/tracking/getTrackAndGoodsByNumber" transportNumber:self.transportNumber];
        
    }
    
    
}
- (void)requestGetTrackingByNumberSuccess:(id)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        self.tableView.hidden = YES;
        _BottomView.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        _BottomView.hidden = YES;

        self.view.backgroundColor = BgColorOfUIView;
        _detailModel = [JYOrderDetailModel mj_objectWithKeyValues:resultDic];
        self.searchModelArr = _detailModel.jyTransportationTrackings;
        
        
    }
    
    [self.tableView reloadData];
    
}

- (void)requestGetTrackingByNumberFailed:(NSError *)error{
    self.tableView.hidden = YES;
    _BottomView.hidden = NO;

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        
        return self.searchModelArr.count;
        
    }else{
        
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 49;
    }else if (indexPath.section == 1 || indexPath.section == 2 ){
        
        return 40;
    }else if (indexPath.section == 3){
        
        return 50;
    }else{
        return 87;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        JYLineTableViewCell *cel = [JYLineTableViewCell cellWithTableView:tableView];
        cel.lineLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        cel.lineLabel.textColor = BGBlue;
        cel.lineLabel.text = [NSString stringWithFormat:@"订单编号： %@",_detailModel.orderNo];
        
        return cel;
        
    }else if (indexPath.section == 1 ) {
        JYGrabTableViewCellThird *cel = [JYGrabTableViewCellThird cellWithTableView:tableView];
        [cel setvalueforCellRowTwo:_detailModel.jyCargoDetails];
        
        return cel;
        
    }else if (indexPath.section == 2 ) {
        JYGrabTableViewCellThird *cel = [JYGrabTableViewCellThird cellWithTableView:tableView];
        [cel setvalueforCellRowThree:_detailModel.jyCargoDetails isInsure:_detailModel.isInsure];
        
        return cel;
        
    }else if (indexPath.section == 3) {
        
        JYLookLogisticsTableViewCellSecond *cell = [JYLookLogisticsTableViewCellSecond cellWithTableView:tableView];
        cell.statuName.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
        cell.timeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
        cell.statuName.textColor = RGB(153, 153, 153);
        cell.timeLabel.textColor = RGB(153, 153, 153);
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            
            cell.statuName.textColor = BGBlue;
            cell.timeLabel.textColor = BGBlue;
            JYTransportModel *model = self.searchModelArr[indexPath.row];
            cell.statuName.text =model.content;
            NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
            NSString *operation = array[0];
            cell.timeLabel.text = operation;

            return cell;
            
        }
        if (self.searchModelArr.count > 0) {
            
            if (indexPath.row == self.searchModelArr.count -1) {
                cell.imgView.image = [UIImage imageNamed:@"icon_huisexian"];
                JYTransportModel *model = self.searchModelArr[indexPath.row];
                cell.statuName.text =model.content;
                
                NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
                NSString *operation = array[0];
                cell.timeLabel.text = operation;

                return cell;
            } else{
                
                cell.imgView.image = [UIImage imageNamed:@"icon_jingguo"];
                JYTransportModel *model = self.searchModelArr[indexPath.row];
                cell.statuName.text =model.content;
                
                NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
                NSString *operation = array[0];
                cell.timeLabel.text = operation;

                return cell;
                
            }
        }
        return cell;
        
    }else {
        
        JYLooklogisticsTableViewCell *cell = [JYLooklogisticsTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.model = _detailModel;
        return cell;
        
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 9;
    }else if (section == 5){
        
        return 9;
    }else{
        return 1;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
