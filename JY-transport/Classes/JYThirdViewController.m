//
//  JYSecondViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYThirdViewController.h"
#import "JYShipServicesTabcell.h"
#import "JYShipOrderDetailTableViewCell.h"
#import "JYShipLineTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYDistributionTableViewCell.h"
#import "JYEvaluteTableViewCell.h"
#import "JYSendDescriptionViewController.h"

#import "JYSwitchTableViewCell.h"
#import "JYSwitchEvulteTableViewCell.h"
#import "JYFileTableViewCell.h"

#import "YBPopupMenu.h"
#import "JYLookAddressViewController.h"

#import "JYAddressDetailViewController.h"


@interface JYThirdViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YBPopupMenuDelegate,MapViewControllerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger lineNum; //用于标记是否投保
@property (nonatomic,assign)NSInteger linefile; //用于标记点击大小文件

@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,assign)NSInteger btntag;

@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;


@property (nonatomic,strong)NSString *startLabel;
@property (nonatomic,strong)NSString *startSubLabel;
@property (nonatomic,strong)NSString *endLabel;
@property (nonatomic,strong)NSString *endSubLabel;

@property (nonatomic,strong)NSString *volume;//体积
@property (nonatomic,strong)NSString *number;//数量
@property (nonatomic,strong)NSString *weight;//重量
@property (nonatomic,strong)NSString *package;//包装
@property (nonatomic,strong)NSString *evulteStr;//价值
@property (nonatomic,strong)NSString *name;//货物名称
@property (nonatomic,strong)NSString *evulteMoney;
@property (nonatomic,strong)JYSwitchEvulteTableViewCell *evuleteCell;

@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *yueBtn;



@end

@implementation JYThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lineNum = 1;
    _linefile = 0;
    _startLabel = @"";
    _startSubLabel = @"";
    _endLabel = @"";
    _endSubLabel = @"";
    _volume = @"";
    _number = @"";
    _weight = @"";
    _package = @"";
    _evulteStr = @"";
    _name = @"";
    _evulteMoney = @"";
    [self creatTableView];
    [self creatBtn];
    [self.tableView reloadData];
    _titleArr = @[@"2", @"3", @"4"];
    
    [self initBMKMapLocation];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
}
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight -42 -50 - NavigationBarHeight - StateBarHeight);
    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight-42,ScreenWidth -135, 50);
    _yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight -StateBarHeight- 50- 42, 135, 50);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -42 -50 -NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 45;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}
- (void)initBMKMapLocation{

    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _geoCodeSearch.delegate = nil;
}
- (void)creatBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight-42,ScreenWidth -135, 50);
    [sureBtn setTitle:@"即时发货" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:BGBlue];
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight - StateBarHeight- 50- 42, 135, 50);
    [yueBtn setTitle:@"预约" forState:UIControlStateNormal];
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [yueBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _yueBtn = yueBtn;
    
    //设置button正常状态下的图片
    [yueBtn setImage:[UIImage imageNamed:@"icon_yuyueshijian"] forState:UIControlStateNormal];
    //设置button高亮状态下的背景图
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    yueBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
    //button标题的偏移量，这个偏移量是相对于图片的
    yueBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.view addSubview:yueBtn];
    
}

- (void)sureBtnClick:(UIButton *)button{
    
    JYAddressDetailViewController *vc = [[JYAddressDetailViewController alloc] init];
    vc.address = _startLabel;
    vc.addressSend = _endLabel;
    [self.navigationController pushViewController:vc animated:YES];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 7;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2){
        return _linefile;
    }else if (section == 3){
        return _lineNum;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 2) {
    if (_linefile != 4) {
        return 0;
    }else{
        return 9;
    }
        
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
        cellLine.startLabel.text = @"";
        cellLine.endLabel.text = @"";
        [cellLine.startLocationBtn setImage:[UIImage imageNamed:@"icon_dingwei"] forState:(UIControlStateNormal)];
        [cellLine.startLocationBtn addTarget:self action:@selector(locationUserLocation:) forControlEvents:UIControlEventTouchUpInside];
        cellLine.lookStartAddressBtn.tag = 100;
        cellLine.lookEndAddressBtn.tag = 101;
        [cellLine.lookStartAddressBtn addTarget:self action:@selector(lookAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellLine.lookEndAddressBtn addTarget:self action:@selector(lookAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_startSubLabel.length > 0) {
            cellLine.startLabel.text = _startLabel;
            cellLine.startSubLabel.text = _startSubLabel;
            cellLine.startPlaehoder.hidden =YES;
            
            cellLine.startLabel.textColor = RGB(102, 102, 102);
            cellLine.startLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];

            
        }
        if (_endLabel.length > 0) {
            
            cellLine.endLabel.text = _endLabel;
            cellLine.endSubLabel.text = _endSubLabel;
            cellLine.endPlaceHoder.hidden =YES;
            
            cellLine.endLabel.textColor = RGB(102, 102, 102);
            cellLine.endLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];

        }
        
        
        return cellLine;

    }else if (indexPath.section == 1){
       
        JYFileTableViewCell *cellDes = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYFileTableViewCell class]) owner:nil options:0][0];
        [cellDes.file setBackgroundImage:[UIImage imageNamed:@"icon_wenjian_weixuanzhong"] forState:(UIControlStateNormal)];
        [cellDes.file setBackgroundImage:[UIImage imageNamed:@"icon_wenjian_xuanzhongzhuangtai"] forState:(UIControlStateSelected)];
        cellDes.file.selected = YES;
        [cellDes.bigFile setBackgroundImage:[UIImage imageNamed:@"icon_dajian_weixuanzhong"] forState:(UIControlStateNormal)];
        [cellDes.bigFile setBackgroundImage:[UIImage imageNamed:@"icon_dajian_xuanzhongzhuangtai"] forState:(UIControlStateSelected)];
        [cellDes.smallFile setBackgroundImage:[UIImage imageNamed:@"icon_xiaojian_weixuanzhong"] forState:(UIControlStateNormal)];
        [cellDes.smallFile setBackgroundImage:[UIImage imageNamed:@"icon_xiaojian"] forState:(UIControlStateSelected)];
        [cellDes.file addTarget:self action:@selector(fileBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
         [cellDes.smallFile addTarget:self action:@selector(fileBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
         [cellDes.bigFile addTarget:self action:@selector(fileBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cellDes.selectionStyle = UITableViewCellSelectionStyleNone; 
        cellDes.file.tag = 1234;
        cellDes.smallFile.tag = 1235;
        cellDes.bigFile.tag = 1236;
        return cellDes;
    }else if (indexPath.section == 2){
        
        JYShipOrderDetailTableViewCell *cellOrd = [JYShipOrderDetailTableViewCell cellWithTableView:tableView];
        [cellOrd.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cellOrd.textField.delegate = self;
        cellOrd.textField.returnKeyType = UIReturnKeyDone;
        cellOrd.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = @{NSForegroundColorAttributeName:RGBA(204, 204, 204, 1),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:14]};
        
        cellOrd.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dic];
        if (indexPath.row == 0) {
            JYDescripeTableViewCell *cellDe = [JYDescripeTableViewCell cellWithTableView:tableView];
            cellDe.imgView.hidden = YES;
            cellDe.naemLabel.text = @"货物详情";
            cellDe.selectionStyle = UITableViewCellSelectionStyleNone;

            cellDe.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
            return cellDe;
        }else if (indexPath.row == 1){
            cellOrd.nameLabel.text = @"货物名称";
            cellOrd.textField.placeholder = @"电脑桌";
            cellOrd.textField.text = _name;
            cellOrd.textField.tag = 372;
            return cellOrd;
        }else if (indexPath.row == 2){
            cellOrd.nameLabel.text = @"体积m³       ";
            cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cellOrd.textField.placeholder = @"长 * 宽 * 高";
            cellOrd.textField.tag = 373;
            cellOrd.textField.text = _volume;
            return cellOrd;
        }else if (indexPath.row == 3){
            
            cellOrd.nameLabel.text = @"数量(件)     ";
            cellOrd.textField.placeholder = @"1";
            cellOrd.textField.keyboardType = UIKeyboardTypeNumberPad;
            cellOrd.textField.tag = 374;
            cellOrd.textField.text = _number;
        }else if (indexPath.row == 4){
            cellOrd.nameLabel.text = @"重量(kg)       ";
            cellOrd.textField.placeholder = @"1";
            cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cellOrd.textField.tag = 375;
            cellOrd.textField.text = _weight;
            
        }else {
            
            cellOrd.nameLabel.text = @"包装类型       ";
            cellOrd.textField.placeholder = @"木箱";
            cellOrd.textField.tag = 376;
            cellOrd.textField.text = _package;
            
        }
        return cellOrd;
        
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cell.nameLabel.text = @"是否投保";
            [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (_lineNum == 1) {
                cell.switchBtn.on = NO;
                
            }else{
                cell.switchBtn.on = YES;
                
                
            }
            return cell;
            
        }else{
            JYSwitchEvulteTableViewCell *cell = [JYSwitchEvulteTableViewCell cellWithTableView:tableView];
            cell.nameLabel.font =[UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.nameLabel.textColor = RGBA(102, 102, 102, 1);
            cell.textField.delegate =self;
            cell.textField.tag = 377;
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.nameLabel.text = @"货物价值(元)";
            cell.evulteLabel.textColor = BGBlue;
            _evuleteCell = cell;

            return cell;
        }
  
    }
    if (indexPath.section == 4) {
        
        JYDescripeTableViewCell *cell = [JYDescripeTableViewCell cellWithTableView:tableView];
        cell.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        cell.naemLabel.text = @"货物描述";
        return cell;
    }else if (indexPath.section == 5){
        JYDescripeTableViewCell *cell = [JYDescripeTableViewCell cellWithTableView:tableView];
        cell.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        cell.naemLabel.text = @"配送时间";
        cell.timeLabel.text = @"最快2小时，最慢4小时";

        return cell;
    }else{
        JYEvaluteTableViewCell *cellev = [JYEvaluteTableViewCell cellWithTableView:tableView];
        cellev.selectionStyle = UITableViewCellSelectionStyleNone;

        return cellev;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        return 44;
    }else if (indexPath.section == 3){
        return 44;
    }else if (indexPath.section == 4 || indexPath.section == 5){
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
        
        } if (indexPath.section == 5) {
            

            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
            CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:self.view];
            CGPoint p = rectInSuperview.origin;
            CGFloat x = p.x;
            CGFloat y = p.y;
            CGPoint point = CGPointMake(x + ScreenWidth -50, y + 42 + 64 +20);
            
            //推荐用这种写法
            [YBPopupMenu showAtPoint:point titles:_titleArr icons:nil menuWidth:50 otherSettings:^(YBPopupMenu *popupMenu) {
                popupMenu.dismissOnSelected = NO;
                popupMenu.isShowShadow = YES;
                popupMenu.delegate = self;
                popupMenu.offset = 10;
                popupMenu.itemHeight = 36;
//              popupMenu.type = YBPopupMenuTypeDark;
                popupMenu.backColor = RGBA(105, 181, 240,1);
                popupMenu.textColor = [UIColor whiteColor];
                [popupMenu round:2.0 RectCorners:UIRectCornerAllCorners];
            }];

            
        }
    
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",_titleArr[index]);
    [ybPopupMenu dismiss];
    
}

-(void)switchAction:(id)sender
{
    UIButton *button3 = [self.tableView viewWithTag:1236];
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开");
        _lineNum = 2;
        
        }else{
            
            NSLog(@"关");
            _lineNum = 1;
    }
    if (button3.selected == YES) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        

    }
   }
- (void)fileBtnClick:(UIButton *)btn{
    UIButton *button1 = [self.tableView viewWithTag:1234];
    UIButton *button2 = [self.tableView viewWithTag:1235];
    UIButton *button3 = [self.tableView viewWithTag:1236];

    if (btn.tag == 1234) {
        _linefile = 0;
        button1.selected = YES;
        button2.selected = NO;
        button3.selected = NO;

    }else if (btn.tag == 1235){
        button1.selected = NO;
        button2.selected = YES;
        button3.selected = NO;

        _linefile = 0;
    }else{
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;


        _linefile = 6;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


// 选择地图位置回调－－－赋值
- (void)didSelectAddress:(NSString *)address poi:(NSString *)poi location:(CLLocationCoordinate2D )location
{
    if (_btntag == 100) {
        _startLabel  = poi;
        _startSubLabel = address;
        _longitude = [NSString stringWithFormat:@"%f",location.longitude];
        _latitude = [NSString stringWithFormat:@"%f",location.latitude];
    }
    if (_btntag == 101) {
        _endLabel  = poi;
        _endSubLabel = address;

    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

}
//选择地图位置回调 －－ 获取城市
- (void)cityWideForDayAndHalfDay:(NSString *)city{

}

//定位本地的位置
-(void)locationUserLocation:(UIButton*)button
{
        _btntag = 100;

    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //    _locService.distanceFilter = 10.0;
    //启动LocationService
    [_locService startUserLocationService];


}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    // 取出用户当前的经纬度
    CLLocationCoordinate2D center = userLocation.location.coordinate;

    NSLog(@"location:{lat:%f; lon:%f}", center.latitude, center.longitude);

    _latitude = [NSString stringWithFormat:@"%f",center.latitude];
    _longitude =[NSString stringWithFormat:@"%f",center.longitude];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:center.latitude longitude:center.longitude];
    regeo.requireExtension = YES;


    NSLog(@"===================%f",userLocation.location.coordinate.latitude);
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = center;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];

    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }


}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{

    if (result.address != nil)
    {
        NSLog(@"成功成功获取逆地理编码reGeocode:%@",result.address);

        if (result.poiList.count > 0) {

            BMKPoiInfo *info = result.poiList[0];
//            _city = info.city;

            if (_btntag == 100) {
                _startLabel  = info.name;
                _startSubLabel = info.address;

            }
            if (_btntag == 101) {
                _endLabel  = info.name;
                _endSubLabel = info.address;

            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
 

        }
    }

}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

- (void)lookAddressClick:(UIButton *)button{
    
    _btntag = button.tag;
    JYLookAddressViewController *mapVC = [[JYLookAddressViewController alloc]init];
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];

}
- (void)textFieldDidChange:(UITextField *)textField{
    
    
    
    switch (textField.tag) {
            
        case 372:
            _name = textField.text;
            break;
        case 373:
            _volume = textField.text;
            break;
        case 374:
            _number = textField.text;
            
            break;
        case 375:
            _weight = textField.text;
            
            break;
        case 376:
            
            _package = textField.text;
            
            break;
        case 377:{
            
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


@end
