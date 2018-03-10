//
//  JYSecondViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYSecondViewController.h"
#import "JYShipServicesTabcell.h"
#import "JYShipOrderDetailTableViewCell.h"
#import "JYDescripeTableViewCell.h"
//#import "JYDistributionTableViewCell.h"
#import "JYEvaluteTableViewCell.h"
#import "JYShipLineTableViewCell.h"
#import "JYSendDescriptionViewController.h"
#import "JYSwitchEvulteTableViewCell.h"
#import "JYSwitchTableViewCell.h"

#import "PSCityPickerView.h"
#import "HongKongCityPickerView.h"
#import "JYAddressDetailViewController.h"
#import "JYHomeRequestDate.h"
#import <QiniuSDK.h>


#import "XZPickView.h"
@interface JYSecondViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PSCityPickerViewDelegate,HongKongCityPickerViewDelegate,JYHomeRequestDateDelegate,XZPickViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)NSInteger lineNum;


@property (strong, nonatomic) PSCityPickerView *cityPicker;
@property (nonatomic,strong)NSString *startChoose;// 选择起点
@property (nonatomic,strong)NSString *endChoose;// 选择终点

@property (nonatomic,strong)HongKongCityPickerView *hongkongPickView;

@property (nonatomic,strong)NSString *volume;//体积
@property (nonatomic,strong)NSString *number;//数量
@property (nonatomic,strong)NSString *weight;//重量
@property (nonatomic,strong)NSString *package;//包装
@property (nonatomic,strong)NSString *evulteStr;//价值
@property (nonatomic,strong)NSString *money;//金额
@property (nonatomic,strong)NSString *name;//货物名称
@property (nonatomic,strong)NSString *evulteMoney;
@property (nonatomic,strong)JYSwitchEvulteTableViewCell *evuleteCell;
@property (nonatomic,strong)NSString *city;

@property (nonatomic,strong)NSString *isDistribution;
@property (nonatomic,strong)NSString *isWarehousing;
@property (nonatomic,strong)NSString *selectDate;
@property (nonatomic,strong)NSMutableArray *photoName;
@property (nonatomic,strong)NSMutableArray *photoArr;
@property (nonatomic,assign)NSInteger tag;
@property (nonatomic,strong)NSString *pirce;
@property (nonatomic,strong)NSString *text;

@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *yueBtn;

@end

@implementation JYSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _endChoose = @"";
    _endChoose = @"";
    _tag = 0;
    _pirce = @"";
    _lineNum = 1;
    _photoName = [NSMutableArray array];
    _photoArr = [NSMutableArray array];
    _volume = @"";
    _number = @"";
    _weight = @"";
    _package = @"";
    _evulteStr = @"";
    _money = @"";
    _name = @"";
    _evulteMoney = @"";
    _isDistribution = @"0";
    _isWarehousing = @"0";
    _city = @"";
    _selectDate = @"";
    _text = @"";
    self.view.backgroundColor = BgColorOfUIView;
    [self creatTableView];
    [self creatBtn];
    //添加货物描述返回时，传图片和内容过来
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageAndContent:)
                                                 name:@"imageAndContent"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
  
    
}


- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
     self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -42 -50 - NavigationBarHeight - StateBarHeight);
    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight-42,ScreenWidth -135, 50);
    _yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight -StateBarHeight- 50- 42, 135, 50);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight -42 -50 - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor =BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //为了让tableview 第一行显示和屏幕一样宽
    UIView *backGround = [[UIView alloc] initWithFrame:CGRectMake(-7, 1, 7, 150)];
    backGround.backgroundColor = [UIColor whiteColor];
    self.tableView.clipsToBounds = NO;
    
    UIView *backGroundTwo = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 7, 1, 7, 150)];
    backGroundTwo.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:backGround];
    [self.tableView addSubview:backGroundTwo];
    
}
#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district ProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID
{
    if (city == nil  || province == nil) {
        city = @"北京";
        province = @"北京";
        district = @"东城区";
    }
    
        
    _startChoose = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)HongKongCityPickerView:(HongKongCityPickerView *)picker finishPickProvince :(NSString *)province city:(NSString *)city{
    
    if (city == nil  || province == nil) {

        province = @"";
        city = @"";
    }
    _city = city;
    _endChoose = [NSString stringWithFormat:@"%@ %@",province,city];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] initWithFrame:CGRectMake(12, ScreenHeight - 220, ScreenWidth - 24, 220)];
        _cityPicker.ComponentNum = 3;
        _cityPicker.ComponentWidth = (ScreenWidth - 50)/3;
        _cityPicker.ComponentRowheight = 40;
        _cityPicker.backgroundColor = [UIColor whiteColor];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}
- (HongKongCityPickerView *)hongkongPickView{
    
    if (!_hongkongPickView)
    {
        _hongkongPickView = [[HongKongCityPickerView alloc] initWithFrame:CGRectMake(12, ScreenHeight - 220, ScreenWidth - 24, 220)];
        _hongkongPickView.backgroundColor = [UIColor whiteColor];
        _hongkongPickView.hongkongDelegate = self;
    }
    return _hongkongPickView;
    
}
- (void)creatBtn{
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight-42,ScreenWidth -135, 50);
    [sureBtn setTitle:@"即时发货" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:BGBlue];
    sureBtn.tag = 752;
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight -StateBarHeight- 50- 42, 135, 50);
    [yueBtn setTitle:@"预约" forState:UIControlStateNormal];
    yueBtn.tag = 753;
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [yueBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置button正常状态下的图片
    [yueBtn setImage:[UIImage imageNamed:@"icon_yuyueshijian"] forState:UIControlStateNormal];
    //设置button高亮状态下的背景图
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    yueBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
    //button标题的偏移量，这个偏移量是相对于图片的
    yueBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _yueBtn = yueBtn;
    [self.view addSubview:yueBtn];

}
- (void)sureBtnClick:(UIButton *)button{
    
    [self judgeParameter:button.tag];
}
- (void)judgeParameter:(NSInteger)tag{
    
    _tag = tag;
    
    if (_startChoose.length <= 0) {
        
        [MBProgressHUD showError:@"寄件人地址不能为空"];
        
    }else if (_endChoose.length <= 0){
        
        [MBProgressHUD showError:@"收件人地址不能为空"];
        
    }else if (_name.length <= 0){
        
        [MBProgressHUD showError:@"货物名字不能为空"];
    }else if (_volume.length <= 0){
        
        [MBProgressHUD showError:@"货物体积不能为空"];
    }else if (_number.length <= 0){
        
        [MBProgressHUD showError:@"货物数量不能为空"];
        
    }else if (_weight.length <= 0){
        
        [MBProgressHUD showError:@"货物重量不能为空"];
        
    }else if (_package.length <= 0){
        
        [MBProgressHUD showError:@"货物包装不能为空"];
        
    }else{
        
        if (tag == 752) {
            [self postRequestDataForHongkong];
        }
        if (tag == 753) {
            
            [self presentChooseTime];
        }
        
        
    }
}
- (void)presentChooseTime{
    
    XZPickView *vc = [[XZPickView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"请选择"];
    vc.delegate = self;
    [vc show];
    
}
- (void)getDataFromConfirmButtonClick:(NSString *)selectDate{
    
    _selectDate = selectDate;
    [self postRequestDataForHongkong];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 8;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 ||section == 1) {
        return 1;
    }else if (section == 2){
        return 5;
    }else if (section == 3){
        return _lineNum;
    }
    else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 2) {
        return 1;
    }else{
        return 9;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cellDef = [tableView dequeueReusableCellWithIdentifier:@"cl"];
    if (!cellDef) {
        cellDef = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cl"];
    }
        
        if (indexPath.section == 0) {
            JYShipLineTableViewCell *cellLine = [JYShipLineTableViewCell cellWithTableView:tableView];
            cellLine.frame = CGRectMake(0, 0, ScreenWidth, 150);
            cellLine.startLabel.hidden =YES;
            cellLine.endLabel.hidden = YES;
            [cellLine.startLocationBtn setImage:[UIImage imageNamed:@"icon_dingwei"] forState:(UIControlStateNormal)];
            cellLine.startLocationBtn.hidden = YES;
            cellLine.lookStartAddressBtn.tag = 110;
            cellLine.lookEndAddressBtn.tag = 111;
            
            if (_startChoose.length > 0) {
                
                 cellLine.startPlaehoder.textColor = RGB(102, 102, 102);
                cellLine.startPlaehoder.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
                 cellLine.startPlaehoder.text = _startChoose;
            }
            if (_endChoose.length > 0) {
                
                cellLine.endPlaceHoder.text = @"请输入收件人地址";
                cellLine.endPlaceHoder.textColor = RGB(102, 102, 102);
                cellLine.endPlaceHoder.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
                cellLine.endPlaceHoder.text = _endChoose;
            }
           
            
            [cellLine.lookStartAddressBtn addTarget:self action:@selector(lookAddressClick:) forControlEvents:UIControlEventTouchUpInside];
            [cellLine.lookEndAddressBtn addTarget:self action:@selector(lookEndAddressClick:) forControlEvents:UIControlEventTouchUpInside];
            return cellLine;
        }else if (indexPath.section == 1){
            
            JYDescripeTableViewCell *cellDes = [JYDescripeTableViewCell cellWithTableView:tableView];
            cellDes.selectionStyle = UITableViewCellSelectionStyleNone;

            cellDes.imgView.hidden = YES;
            cellDes.naemLabel.text = @"货物详情";
            cellDes.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
            return cellDes;
        }else if (indexPath.section == 2){
            JYShipOrderDetailTableViewCell *cellOrd = [JYShipOrderDetailTableViewCell cellWithTableView:tableView];
            cellOrd.textField.delegate = self;
            cellOrd.textField.returnKeyType = UIReturnKeyDone;
            cellOrd.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cellOrd.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            NSDictionary *dic = @{NSForegroundColorAttributeName:RGBA(204, 204, 204, 1),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:14]};
            
            cellOrd.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dic];
            
            if (indexPath.row == 0){
                cellOrd.nameLabel.text = @"货物名称";
                cellOrd.textField.placeholder = @"电脑桌";
                cellOrd.textField.text = _name;
                cellOrd.textField.tag = 772;
                 return cellOrd;
            }else if (indexPath.row == 1){
                cellOrd.nameLabel.text = @"体积m³       ";
                cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
                cellOrd.textField.placeholder = @"长 * 宽 * 高";
                cellOrd.textField.tag = 773;
                cellOrd.textField.text = _volume;
                 return cellOrd;
            }else if (indexPath.row == 2){
                
                cellOrd.nameLabel.text = @"数量(件)     ";
                cellOrd.textField.placeholder = @"1";
                cellOrd.textField.keyboardType = UIKeyboardTypeNumberPad;
                cellOrd.textField.tag = 774;
                cellOrd.textField.text = _number;
            }else if (indexPath.row == 3){
                cellOrd.nameLabel.text = @"重量(kg)       ";
                cellOrd.textField.placeholder = @"1";
                cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
                cellOrd.textField.tag = 775;
                cellOrd.textField.text = _weight;
                
            }else {
                
                cellOrd.nameLabel.text = @"包装类型       ";
                cellOrd.textField.placeholder = @"木箱";
                cellOrd.textField.tag = 776;
                cellOrd.textField.text = _package;
                
            }
            return cellOrd;

        }
            
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cell.nameLabel.text = @"是否投保";
            cell.switchBtn.tag = 320;

            [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (_lineNum == 1) {
                cell.switchBtn.on = NO;
                
            }else{
                cell.switchBtn.on = YES;
                
                
            }
            return cell;
            
        }else{
            JYSwitchEvulteTableViewCell *cell = [JYSwitchEvulteTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.delegate = self;
            cell.nameLabel.font =[UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.nameLabel.textColor = RGBA(102, 102, 102, 1);
            cell.nameLabel.text = @"货物价值(元)";
            cell.textField.tag = 777;
            cell.textField.text = _evulteStr;
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
//            cell.evulteLabel.text = _evulteMoney;
            _evuleteCell = cell;
            return cell;
        }

    }
    if (indexPath.section == 4) {
        JYDescripeTableViewCell *cell = [JYDescripeTableViewCell cellWithTableView:tableView];
        cell.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        return cell;
    }
    if (indexPath.section == 5){
        JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
        cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.nameLabel.text = @"配送";
        cell.switchBtn.on = NO;
        cell.switchBtn.tag = 321;
        [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }  if (indexPath.section == 6){
        JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
        cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.nameLabel.text = @"入仓";
        cell.switchBtn.on = NO;
        cell.switchBtn.tag = 322;

        [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        return cell;
    }else{
        JYEvaluteTableViewCell *cellev = [JYEvaluteTableViewCell cellWithTableView:tableView];
        cellev.selectionStyle = UITableViewCellSelectionStyleNone;
        cellev.moneyLabel.text = [NSString stringWithFormat:@"¥%@",_pirce];
        return cellev;
    }
                
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 2){
        return 44;
    }else if (indexPath.section == 3){
        return 50;
    }else if (indexPath.section == 4 || indexPath.section == 5 ||indexPath.section == 6){
        return 50;
    }else{
        return 84;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 4) {
        JYSendDescriptionViewController *vc = [[JYSendDescriptionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}
-(void)switchAction:(UISwitch*)sender
{
    UISwitch *switct2 = [self.tableView viewWithTag:321];
    UISwitch *switct3 = [self.tableView viewWithTag:322];

    switch (sender.tag) {
        case 320:{
            if (sender.on) {
                NSLog(@"开");
                _lineNum = 2;
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
                [indexPaths addObject: indexPath];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:3];
                [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];

                
            }else {

                NSLog(@"关");
                _lineNum = 1;
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
                [indexPaths addObject: indexPath];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:3];

                [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }

        }
        case 321:{
            if (sender.on) {
                _isDistribution = @"1";
            }else{
                switct3.on = NO;
                _isDistribution = @"0";
                _isWarehousing = @"0";

            }
        
        }
            break;
        case 322:{
            
            if (sender.on) {
                switct2.on = YES;
                _isWarehousing = @"1";
                _isDistribution = @"1";

            }else{
                _isWarehousing = @"0";
            }
            
        }
            break;
        default:
            break;
    }
    
}
- (void)textFieldDidChange:(UITextField *)textField{

    
    switch (textField.tag) {
            
        case 772:
            _name = textField.text;
            break;
        case 773:
            _volume = textField.text;
            break;
        case 774:
            _number = textField.text;
            
            break;
        case 775:
            _weight = textField.text;
            
            break;
        case 776:
            
            _package = textField.text;

            break;
        case 777:{
            
            _evulteStr = textField.text;
            double evulteNum = [_evulteStr doubleValue];
            double evulteMoney = evulteNum * 0.004;
            _evulteMoney = [NSString stringWithFormat:@"%.1f",evulteMoney];
            _evuleteCell.evulteLabel.text = _evulteMoney;
            
        }
       
        default:
            break;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
     [self confirmHongkongPrice];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 773 || textField.tag == 775 || textField.tag == 777 ) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        //首位不能为.号
        if (range.location == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        return [self isRightInPutOfString:textField.text withInputString:string range:range];
        return NO;
        
    }else if(textField.tag == 403){
        
        NSString *passWordRegex = @"^[0-9]*$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        
        if (![passWordPredicate evaluateWithObject:string]) {
            return NO;
        }else{
            
            return YES;
        }
        
    }else{
        return YES;
    }
    
}
- (BOOL)isRightInPutOfString:(NSString *) string withInputString:(NSString *) inputString range:(NSRange) range{
    //判断只输出数字和.号
    NSString *passWordRegex = @"[0-9\\.]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:inputString]) {
        return NO;
    }
    //逻辑处理
    if ([string containsString:@"."]) {
        if ([inputString isEqualToString:@"."]) {
            return NO;
        }
        NSRange subRange = [string rangeOfString:@"."];
        if (range.location - subRange.location > 2) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

- (void)lookAddressClick:(UIButton *)button{
    
    [self.cityPicker showPickView];
    
}
- (void)lookEndAddressClick:(UIButton *)button{
    
    [self.hongkongPickView showPickView];
}

- (void)serviceRightBtnClick:(UIButton *)button{
    button.selected = !button.selected;

}

- (void)confirmHongkongPrice{
    
    if ([self judgeUserchoose]) {
        JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
        manager.delegate = self;
        [manager requsetGetHongkongPrice:@"app/logisticsorder/getHKPrice" region:_city volume:_volume weight:_weight isDistribution:_isDistribution isWarehousing:_isWarehousing];
        
    }
}
   
- (BOOL)judgeUserchoose{
    
    if (_startChoose.length > 0 && _endChoose.length > 0 &&  _volume.length > 0 && _weight.length > 0) {
        
        return YES;
        
    }else{
        return NO;
    }
}

- (void)requsetGetHongkongPriceSuccess:(NSDictionary *)resultDic{
    NSString *str = [resultDic objectForKey:@"message"];
    if ([str isEqualToString:@"404"]){
        
    }else{
        
        _pirce = [resultDic objectForKey:@"price"];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:7];
        [self .tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationNone)];

    }
}

- (void)requsetGetHongkongPriceFailed:(NSError *)error{
    
}

- (void)postRequestDataForHongkong{
    
    NSDictionary *orderHongkongDic = @{@"volume":_volume,
                                       @"number":_number,
                                       @"weight":_weight,
                                       @"package":_package,
                                       @"evulteStr":_evulteStr,
                                       @"money":_money,
                                       @"typeStr":@"",
                                       @"name":_name,
                                       @"insuranceAmount":_evulteMoney,
                                       @"isDistribution":_isDistribution,
                                       @"isWarehousing":_isWarehousing
                               };
    
    JYHomeRequestDate *manager  = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    
    NSString *timeNow = [NSDate  getnowDate:@"yyyy-MM-dd HH:mm:ss"];
    int timeType = 0;
    NSString *time = @"";
    
    if (_tag == 752) {
        
        timeType = 0;
        time = timeNow;

    }if (_tag == 753) {
        
        timeType = 1;
        time = self.selectDate;

    }
        NSString *photoName =  [_photoName componentsJoinedByString:@","];
    if (photoName == nil || [photoName isEqual:[NSNull null]]) {
        photoName = @"";
    }

    [manager requsetCommitDedicatedOrderForHongkong:@"app/logisticsorder/commitDedicatedOrder" evlue:orderHongkongDic startPlace:_startChoose endPlace:_endChoose describeContent:@"" photo:@"" time:time timeType:@(timeType) nowTime:timeNow evaluation:_pirce];
    
}
- (void)requsetHongkongOrderFailed:(NSError *)error{
    
    
}

- (void)requsetHongkongOrderSuccess:(NSDictionary *)resultDic{
    
    
    NSString *meaasge = [resultDic objectForKey:@"message"];
    if ([meaasge isEqualToString:@"500"]) {
        
    }else{
        
        [_photoName removeAllObjects];
        [_photoArr removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imageOrder"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"textOrder"];
        
        JYAddressDetailViewController *vc = [[JYAddressDetailViewController alloc] init];
        vc.address = _endChoose;
        vc.addressSend = _startChoose;
        vc.orderID = meaasge;
        [self.navigationController pushViewController:vc animated:YES];
        
 
    }
    
}
- (void)imageAndContent:(NSNotification*)noti{
    
    _photoName = [NSMutableArray array];
    NSDictionary *dic = noti.userInfo;
    _photoArr = [dic objectForKey:@"bigImgArr"];
    _text = [dic objectForKey:@"text"];
    
    if (_photoArr.count > 0) {
        for (int i = 0; i < _photoArr.count;i++) {
            NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
            NSString *key = [NSString stringWithFormat:@"OrderPhoto%@%@%d",userPhone,keyStr,i];
            [_photoName addObject:key];
            
        }
    }
    
}

//从服务器获取上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        
        
        for (NSInteger i = 0; i < _photoArr.count; i ++) {
            
            [self updateheadimage:voucher index:i];
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
    
}
//上传图片到七牛
- (void)updateheadimage:(NSString *)str index:(NSInteger)index{
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    
    NSString * token = str;
    NSString *key = _photoName[index];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_photoArr[index]];
    
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (index == _photoArr.count - 1) {
            
            //            [self judgeParameter];
        }
        
    } option:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageAndContent" object:nil];
}

@end
