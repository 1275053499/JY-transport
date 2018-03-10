//
//  LookForCarViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LookForCarViewController.h"

#import "serviceDetailTableViewCell.h"
#import "CharteredBusTimeCell.h"
#import "linkmanCell.h"
#import "EvaluateCell.h"
#import "CarInfoCollectionViewCell.h"
#import "PopoverView.h"
#import "LookForCarMapViewController.h"
#import "WSDatePickerView.h"
#import <MAMapKit/MAMapKit.h>
#import "AdBannerView.h"
#import "ServiceTableViewCell.h"
#import "oneTableViewCell.h"
#import "MyCarArrTableViewCell.h"
#import "lookForDriverMapController.h"
#import "returnCarWoringView.h"
#import "platformBidView.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "CarFleetViewController.h"

#import "XZPickView.h"
#import "UserInfoModel.h"
#import "JYSwitchTableViewCell.h"
#import "JYSwitchEvulteTableViewCell.h"
#import "CollectPaymentTableViewCell.h"
#import <IQKeyboardManager.h>
@interface LookForCarViewController ()<UITableViewDelegate,UITableViewDataSource,MapViewControllerDelegate,UITextFieldDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,XZPickViewDelegate>
{
    
    
    int cellCount;
    
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSIndexPath *indexNumber;
/*保存两地之间的距离*/
@property (nonatomic,assign)CGFloat savedistance;


@property (nonatomic,assign)  BOOL isindex;


@property(nonatomic,copy)NSString *time;//出发时间
//联系人姓明
@property(nonatomic,copy)NSString *linkName;//

//联系人手机号码
@property(nonatomic,copy)NSString *linkPhone;//
//一口价的textfield
@property(nonatomic,copy)NSString *giveMoneyPhone;

@property(nonatomic,strong)returnCarWoringView *headerView;
@property(nonatomic,weak)UIView *clealView;
//平台出价的弹框

@property(nonatomic,strong)platformBidView *platformBidView;//弹框
@property(nonatomic,strong)UIView *platformView;//底层遮盖物




//是不是包半日按钮被选择了
@property(nonatomic,assign)BOOL isHalfOfDay;
//是不是包一日按钮被选择了
@property(nonatomic,assign)BOOL isOneOfDay;
//包半日按钮
@property(nonatomic,strong)UIButton *halfOfDayButton;
//包全日按钮
@property(nonatomic,strong)UIButton *dayButton;

@property(nonatomic,assign) NSInteger currentPage;


//储存服务详情所有按钮被点击选择的1,2,3,4
@property(nonatomic,strong)NSMutableArray *allSeletedService;


/*定义属性平台估价的值*/
@property (nonatomic,copy)NSString *evaluateMoney;
@property(nonatomic,strong)AdBannerView *bannerView;
@property(nonatomic,weak)NSString *carTypeName;


// 储存地址的数组
@property(nonatomic,strong)NSMutableArray *PlaceArr;
//储存详细地址的数组
@property(nonatomic,strong)NSMutableArray *PlaceAdressArr;

//储存全体精度－－－经纬
@property(nonatomic,strong)NSMutableArray *LatitudeArr;

//储存全体精度－－－纬度
@property(nonatomic,strong)NSMutableArray *LongitudeArr;



@property (nonatomic,strong)NSMutableArray *vechileTeamArr;//我的车队；

// 储存城市的数组 用于判断是否同城
@property(nonatomic,strong)NSMutableArray *cityArr;

@property (nonatomic,strong)BMKRouteSearch *routesearch;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,strong)NSArray *carName;
@property (nonatomic,strong) UIView *carTypeView;

@property (nonatomic,strong)FMButton *liftButton;
@property (nonatomic,strong)FMButton *rightButton;
//@property (nonatomic,strong)UILabel *bannerViewLabTitle;

@property (nonatomic,assign)NSInteger serviceHeight;
@property (nonatomic,assign)int timeType;//发货 预约（2）还是 即时（1）
@property (nonatomic,strong)NSString *placeholderName;
@property (nonatomic,strong)NSString *placeholderPhone;

@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *yueBtn;

@property (nonatomic,assign)NSInteger PaymentNum;//待收货款行数
@property (nonatomic,strong)NSString *money;
@property (nonatomic,assign)BOOL authentication;//
@end

@implementation LookForCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"我要找车";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self createTableView];
    [self creatBtn];
    self.allSeletedService = [NSMutableArray array];
    self.PlaceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.PlaceAdressArr = [NSMutableArray array];
    self.LatitudeArr = [NSMutableArray array];
    self.LongitudeArr = [NSMutableArray array];
    _timeType = 1;
    _PaymentNum = 1;
    _money = @"";
    _authentication = NO;
    NSArray *endPlaceArr = @[@"",@""];
    [self.PlaceArr addObjectsFromArray:endPlaceArr];
    NSArray *cityarr = @[@"",@""];
    [self.cityArr addObjectsFromArray:cityarr];
    
    NSArray *endPlaceAdressArr = @[@"",@""];
    [self.PlaceAdressArr addObjectsFromArray:endPlaceAdressArr];
    
    _savedistance = 0;
    // 经度
    NSArray *LatitudeArray = @[@"",@""];
    [self.LatitudeArr addObjectsFromArray:LatitudeArray];
    
    
    //纬度
    NSArray *LongitudeArray = @[@"",@""];
    
    [self.LongitudeArr addObjectsFromArray:LongitudeArray];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundhome:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    cellCount = 2;
    _serviceHeight = 4;
    
    _time = @"";
    
    _isHalfOfDay =NO;
    _isOneOfDay = NO;
    _evaluateMoney = @"30";
    
    _giveMoneyPhone = @"";
    _vechileTeamArr = [NSMutableArray array];
    UserInfoModel *userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    _placeholderName = userModel.nickname;
    _placeholderPhone = userPhone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotificiation:) name:@"carTypeChange" object:nil];
    
    
  
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _locService.delegate = self;

    
    _carName = @[@"微面",@"大型面包车",@"依维柯",@"微型货车",@"小型货车",@"中型货车",@"平板车"];
    _carTypeName = _carName[0];
    if (_teamDrMode) {
        [_vechileTeamArr addObject:_teamDrMode];
    }
    
    [self locationUserLocation:nil];
    
}
- (void)creatBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake( 135, ScreenHeight - NavigationBarHeight - StateBarHeight - 50, ScreenWidth -135, 50);
    
    [sureBtn setTitle:@"即时用车" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:BGBlue];
    
    
    sureBtn.tag = 422;
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,135, 50);
    [yueBtn setTitle:@"预约" forState:UIControlStateNormal];
    yueBtn.tag = 423;
    [yueBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _yueBtn = yueBtn;
    [self.view addSubview:yueBtn];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    
}
//// 收到通知改变车型的名字
-(void)receiveNotificiation:(NSNotification*)sender
{
    //    NSArray *arr = @[@"MINIVAN",@"LARGEVAN",@"IVECO",@"MINITRUCK",@"SMALLTRUCK",@"MEDIUMTRUCK"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int progress = [[sender.userInfo objectForKey:@"pageControlPage"] intValue];
        _carTypeName = _carName[progress];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d", progress] forKey:@"pageControlPage"];
        
        [self.allSeletedService removeAllObjects];
        [self judgeWhitchServiceBtnNeedTip];
        
        [self senderHttpReque];
    });
}
//退出
#pragma mark - action handle
- (void)returnAction
{
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}
//确定下单
- (BOOL)confirmOrder{
    
    if (self.LatitudeArr.count >= 2) {
        
        NSString *strOne = self.LatitudeArr[0];
        NSString *strTwo = self.LatitudeArr[1];
        if (strOne.length <=0 || strTwo.length <= 0) {
            [MBProgressHUD showSuccess:@"请检查地址是否漏填"];
            return NO;
        }
        
    }
    
    if ([[_linkName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 && _placeholderName.length <=0 ) {
        
        [MBProgressHUD showSuccess:@"联系人名字是否漏填"];
        return NO;
        
    }else if ([[_linkPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 && _placeholderPhone.length <=0 ) {
        
        [MBProgressHUD showSuccess:@"请检查联系人电话是否漏填"];
        return NO;
        
    }else if (_giveMoneyPhone.length <= 0 ){
        
        [MBProgressHUD showSuccess:@"请检查你的出价是否漏填"];
        return NO;
        
    } else{
        
        return YES;
    }
    
}

//点击确定按钮
-(void)sureBtnClick:(UIButton *)btn
{
    BOOL confirmOrder = [self confirmOrder];
    
    if (btn.tag == 423) {
        
        if (confirmOrder) {
            
            XZPickView *vc = [[XZPickView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"请选择"];
            _timeType = 2;
            vc.delegate = self;
            [vc show];
        }
    }else{
        
        _time = [NSDate  getnowDate:@"yyyy-MM-dd HH:mm"];
        _timeType = 1;
        if (confirmOrder) {
            _sureBtn.enabled = NO;
            [self clickLookForCarSureButtonHttp];
        }
    }
    
}
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 50);
    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,ScreenWidth -135, 50);
    _yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight - StateBarHeight - 50, 135, 50);
    
    
}

//创建UItableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        //        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 9;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }
}
#pragma mark UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return cellCount;
        
    }else if (section == 2){
        if (_vechileTeamArr.count>0) {
            return 2;
        }else{
            return 1;
        }
    }else if (section == 3){
        
        return _serviceHeight;
        
    }else if (section == 4){
        
        return _PaymentNum;
        
    }else{
        
        return 1;
        
    }
    
}
- (void)addBtnClick:(UIButton *)btn{
    [_vechileTeamArr removeAllObjects];
    [_tableView reloadData];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        oneTableViewCell *cell = [oneTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.startPlace.text = self.PlaceArr[indexPath.row];
        cell.startPlaceDistrict.text = self.PlaceAdressArr[indexPath.row];
        
        if (indexPath.row == 0) {
            
            cell.iconImage.image = [UIImage imageNamed:@"startPlace"];
            
            [cell.locationButton addTarget:self action:@selector(locationUserLocation:) forControlEvents:UIControlEventTouchUpInside];
            
            if (cell.startPlace.text.length <= 0) {
                
                cell.placeType.text = @"点击选择出发地";
            }else{
                cell.placeType.hidden = YES;
                
            }
            return cell;
            
        }else{
            
            if (cellCount==2 && indexPath.row==1) {
                
                cell.iconImage.image = [UIImage imageNamed:@"destination-1"];
                [cell.locationButton setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                
                //增加临界地址
                [cell.locationButton addTarget:self action:@selector(addCellClick:) forControlEvents:UIControlEventTouchUpInside];
                if (cell.startPlace.text.length <= 0) {
                    
                    cell.placeType.text = @"点击选择目的地";
                }else{
                    cell.placeType.hidden = YES;
                }
                return cell;
                
            }else{
                
                
                if (cellCount >2 && indexPath.row == 1) {
                    
                    cell.iconImage.image = [UIImage imageNamed:@"pass"];
                    [cell.locationButton addTarget:self action:@selector(addCellClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.locationButton setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                    if (cell.startPlace.text.length <= 0) {
                        
                        cell.placeType.text = @"点击选择目的地";
                    }else{
                        cell.placeType.hidden = YES;
                    }
                    return cell;
                    
                    
                }else if (cellCount >2 && indexPath.row == cellCount-1){
                    
                    
                    cell.iconImage.image = [UIImage imageNamed:@"destination-1"];
                    [cell.locationButton setImage:[UIImage imageNamed:@"gray_delete"] forState:UIControlStateNormal];
                    
                    cell.locationButton.tag = 800+indexPath.row;
                    
                    [cell.locationButton addTarget:self action:@selector(removeCellClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (cell.startPlace.text.length <= 0) {
                        
                        cell.placeType.text = @"点击选择目的地";
                    }else{
                        cell.placeType.hidden = YES;
                    }
                    return cell;
                    
                }else{
                    
                    cell.iconImage.image = [UIImage imageNamed:@"pass"];
                    [cell.locationButton setImage:[UIImage imageNamed:@"gray_delete"] forState:UIControlStateNormal];
                    cell.locationButton.tag = 800+indexPath.row;
                    [cell.locationButton addTarget:self action:@selector(removeCellClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (cell.startPlace.text.length <= 0) {
                        
                        cell.placeType.text = @"点击选择目的地";
                    }else{
                        cell.placeType.hidden = YES;
                    }
                    return cell;
                    
                    
                }
            }
        }
        
    }else if (indexPath.section == 1){
        
        static NSString *CellIdentifier = @"adcell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.contentView.backgroundColor = BgColorOfUIView;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
            [cell.contentView addSubview:view];
            [view addSubview:[self creatCellContent]];
            if (_vechileTeamArr.count > 0) {
                DriverInfoMode *model = _vechileTeamArr[0];
                _bannerView.titleLabel.text = model.vehicleChs;
                _carTypeName = model.vehicleChs;
                NSString *vehicleS =  [self judgeVechileisTypeEnglish:model.vehicleChs];
                _bannerView.currentImageView.image = [UIImage imageNamed:vehicleS];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.userInteractionEnabled = NO;
                
            }
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        
        
        MyCarArrTableViewCell * cell = [MyCarArrTableViewCell cellWithTableView:tableView];
        cell.lineView.hidden = YES;
        
        cell.imgView.image = [UIImage imageNamed:@"icon_jiantou2"];
        cell.nameLabel.text = @"我的车队";
        cell.stateLabel.text = @"添加";
        cell.stateLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
        cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
        cell.imgView.hidden = NO;
        if (_vechileTeamArr.count > 0 ) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITableViewCell *cel = [[UITableViewCell alloc] init];
            cel.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imgView.hidden = YES;
            if (indexPath.row == 1) {
                DriverInfoMode *model = _vechileTeamArr[0];
                cel.textLabel.text =model.name;
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(0, 0, 25, 25);
                [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
                cel.accessoryView = deleteBtn;
                return cel;
            }
            
        }
        return cell;
        
    }else if (indexPath.section == 3){
        
        if (indexPath.row == 0) {
            MyCarArrTableViewCell * cell = [MyCarArrTableViewCell cellWithTableView:tableView];
            
            NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"服务详情"];
            NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:14],NSForegroundColorAttributeName:RGB(102, 102, 102),};
            
            [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
            NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@" (注：搬运费需要与司机协商)"];
            
            NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:12],NSForegroundColorAttributeName:RGB(102, 102, 102),};
            [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
            [firstPart appendAttributedString:secondPart];
            cell.nameLabel.attributedText = firstPart;
            
            return cell;
        }else {
            serviceDetailTableViewCell *cell = [serviceDetailTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.leftBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.rightBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (indexPath.row == 1) {
                cell.lineViewTopConstraint.constant = 10;
                
            }
            if (indexPath.row == _serviceHeight - 1) {
                cell.linViewBottomConstraint.constant = 10;
            }
            [cell setServiceBtnImage:indexPath serviceArr:_allSeletedService];
            
            [cell layoutIfNeeded];
            
            return cell;
            
        }
        
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:15];
            cell.nameLabel.text = @"代收货款";
            cell.nameLabel.textColor = RGB(51, 51, 51);
            cell.switchBtn.tag = 321;
            
            [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (_PaymentNum == 1) {
                cell.switchBtn.on = NO;
                
            }else{
                cell.switchBtn.on = YES;
                
            }
            return cell;
            
        }else{
            CollectPaymentTableViewCell *cell = [CollectPaymentTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textMoney.returnKeyType = UIReturnKeyDone;
            cell.textMoney.delegate = self;
            cell.textMoney.tag = 10004;
            cell.textMoney.text =  _money;
            cell.textMoney.keyboardType = UIKeyboardTypeDecimalPad;
            [cell.textMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            
            return cell;
        }
        
    }else if (indexPath.section == 5){
        JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:15];
        cell.nameLabel.text = @"指定认证司机接单";
        cell.nameLabel.textColor = RGB(51, 51, 51);
        cell.switchBtn.tag = 335;
        cell.switchBtn.on = NO;
        
        [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
        
    }else if (indexPath.section == 6){
        
        linkmanCell *cell = [linkmanCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.linkmanName.delegate =self;
        cell.phoneNumber.delegate = self;
        cell.linkmanName.tag = 10001;
        cell.phoneNumber.tag =10002;
        cell.phoneNumber.textColor = BGBlue;
        cell.linkmanName.textColor = RGBA(51, 51, 51, 1);
        cell.phoneNumber.returnKeyType =UIReturnKeyDone;
        cell.linkmanName.returnKeyType =UIReturnKeyDone;
        cell.linkmanName.placeholder = _placeholderName;
        cell.phoneNumber.placeholder = _placeholderPhone;
        if (_linkName.length > 0) {
            cell.linkmanName.text = _linkName;
            
            
        }if (_linkPhone.length > 0) {
            
            cell.phoneNumber.text = _linkPhone;
        }
        
        [cell.linkmanName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
        [cell.phoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
        
        return cell;
        
    }else if (indexPath.section == 7){
        
        MyCarArrTableViewCell * cell = [MyCarArrTableViewCell cellWithTableView:tableView];
        cell.lineView.hidden = YES;
        cell.nameLabel.text = @"查看价格明细";
        cell.nameLabel.textColor = RGB(51, 51, 51);
        
        cell.textLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];
        cell.accessoryView = imgView;
        return cell;
    }else{
        EvaluateCell *cell = [EvaluateCell cellWithTableView:tableView];
        
        cell.giveMoneyTextField.tag = 10003;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.giveMoneyTextField.delegate = self;
        if (_savedistance <= 0) {
            cell.evaluateLabel.textColor = RGB(153, 153, 153);
            NSDictionary *att = @{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:20]};
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"请输入金额" attributes:att];
            [cell.giveMoneyTextField setAttributedPlaceholder:attString];
        }
        cell.giveMoneyTextField.textColor = RGB(51, 51, 51);
        NSString *distanceStr = [NSString stringWithFormat:@"%.0fkm",self.savedistance];
        cell.evaluateLabel.text = distanceStr;
        cell.giveMoneyTextField.returnKeyType =UIReturnKeyDone;
        [cell.giveMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
        
        cell.giveMoneyTextField.text = _giveMoneyPhone;
        
        cell.warningLabel.hidden = YES;
        
        return cell;
        
    }
    
}
- (NSString *)judgeVechileisTypeEnglish:(NSString *)vechileTypeStr{
    if ([vechileTypeStr isEqualToString:@"微面"]) {
        return @"micro_facet";
    }else if ([vechileTypeStr isEqualToString:@"大型面包车"]){
        return @"big_minibus";
    }else if ([vechileTypeStr isEqualToString:@"依维柯"]){
        return  @"iveco";
    }else if ([vechileTypeStr isEqualToString:@"微型货车"]){
        return  @"mini_truck";
    }else if ([vechileTypeStr isEqualToString:@"小型货车"]){
        return  @"light_van";
    }else if ([vechileTypeStr isEqualToString:@"中型货车"]){
        return @"medium_truck";
    }else if ([vechileTypeStr isEqualToString:@"平板车"]){
        return @"pingbanche";
    }else{
        return @"";
    }
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    switch (textField.tag) {
        case 10001:
            _linkName = textField.text;
            break;
        case 10002:
            _linkPhone = textField.text;
            break;
        case 10003:
            _giveMoneyPhone = textField.text;
            break;
            
        case 10004:
            _money = textField.text;
            
            break;
        default:
            break;
    }
}
- (void)serviceBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [self.allSeletedService addObject:[NSString stringWithFormat:@"%ld", btn.tag - 2000]];
        
    }else{
        
        [self.allSeletedService removeObject:[NSString stringWithFormat:@"%ld", btn.tag - 2000]];
    }
    
    
}
-(void)tapAvatarView
{
    
    self.platformView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    self.platformView.backgroundColor = RGBA(0, 0, 0, 0.4);
    
    [self.view addSubview:self.platformView];
    self.platformBidView = [[platformBidView alloc]initWithFrame:CGRectMake((ScreenWidth - 312)/2, (ScreenHeight - 250 - 64 - 50)/2, 312, 250)];
    
    self.platformBidView.carType = _carTypeName;
    self.platformBidView.savedistance = _savedistance;
    self.platformBidView.money = _evaluateMoney;
    
    self.platformBidView.backgroundColor = [UIColor whiteColor];
    [self.platformView addSubview:self.platformBidView];
    
}



//定位本地的位置
-(void)locationUserLocation:(UIButton*)button
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        
        // 没开启权限
        [self presentTipAlertAuthStatus:@"定位服务未开启，请在iPhone的\"设置-隐私-定位服务\"中开启!"];
    }else{
        
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        //    _locService.distanceFilter = 10.0;
        //启动LocationService
        [_locService startUserLocationService];
    }
   
}
- (void)presentTipAlertAuthStatus:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    //点击按钮的响应事件
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    // 取出用户当前的经纬度
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    NSLog(@"location:{lat:%f; lon:%f}", center.latitude, center.longitude);
    
    [self.LatitudeArr replaceObjectAtIndex:0 withObject: [NSString stringWithFormat:@"%f",center.latitude]];
    [self.LongitudeArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",center.longitude]];
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
            [self.cityArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@", info.city]];
            [self.PlaceArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",info.address]];
            [self.PlaceAdressArr replaceObjectAtIndex:0 withObject:info.name];
            
            [self.allSeletedService removeAllObjects];
            
            [self.tableView reloadData];
            
            
        }
    }
    
}


-(void)addCellClick:(UIButton *)button
{
    
    if (cellCount >4) {
        
        return;
    }
    
    [self.PlaceArr addObject:@""];
    [self.cityArr addObject:@""];
    [self.PlaceAdressArr addObject:@""];
    [self.LatitudeArr addObject:@""];
    [self.LongitudeArr addObject:@""];
    
    [self.allSeletedService removeAllObjects];
    cellCount ++;
    [self.tableView reloadData];
    
    
    
}
-(void)removeCellClick:(UIButton *)button
{
    
    
    [self.cityArr removeObjectAtIndex:(button.tag -800)];
    [self.PlaceArr removeObjectAtIndex:(button.tag-800)];
    [self.PlaceAdressArr removeObjectAtIndex:(button.tag-800)];
    [self.LatitudeArr removeObjectAtIndex:(button.tag-800)];
    [self.LongitudeArr removeObjectAtIndex:(button.tag -800)];
    cellCount --;
    [self.allSeletedService removeAllObjects];
    [self.tableView reloadData];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 63;
    }else if (indexPath.section == 1){
        return 140;
        
    }else if (indexPath.section == 2){
        return 50;
        
    }else if (indexPath.section == 3){
        
        return 50;
        
    }else if (indexPath.section == 4){
        
        return 50;
        
    }else if (indexPath.section == 5){
        
        return 50;
        
    }else if (indexPath.section == 6){
        return 142;
        
    }else if (indexPath.section == 7){
        return 50;
        
    }else if (indexPath.section == 8){
        return 100;
        
    }else{
        
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        
        return 9;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
    
}
-(UIView *)creatCellContent
{
    
    if (_carTypeView == nil) {
        _carTypeView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 140)];
        _carTypeView.backgroundColor = [UIColor whiteColor];
    }
    if (_bannerView == nil) {
        int height = 70 * HOR_SCALE + 50; //scrollview高加label高
        _bannerView = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height )];
        _bannerView.carName = @[@"微面",@"大型面包车",@"依维柯",@"微型货车",@"小型货车",@"中型货车",@"平板车"];
        [_bannerView initWithImage:@[@"micro_facet",@"big_minibus",@"iveco",@"mini_truck",@"light_van",@"medium_truck",@"pingbanche"]];
        
        [_carTypeView addSubview:_bannerView];
        [self.view addSubview:_carTypeView];
    }
    
    return _carTypeView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexNumber = indexPath;
    if (indexPath.section == 0) {
        
        LookForCarMapViewController *mapVC = [[LookForCarMapViewController alloc]init];
        mapVC.delegate = self;
        [self.navigationController pushViewController:mapVC animated:YES];
    }else if (indexPath.section == 1) {
        
        
    }else if (indexPath.section == 2) {
        
        if (_vechileTeamArr.count > 0) {
            
        }else{
            CarFleetViewController *carFleetVC = [[CarFleetViewController alloc]init];
            carFleetVC.pushFromVC = @"LookForCarViewController";
            carFleetVC.passOnName =^(DriverInfoMode *mode) {
                [_vechileTeamArr addObject:mode];
                if ([mode.vehicle isEqualToString:@"MINITRUCK"] || [mode.vehicle isEqualToString:@"SMALLTRUCK"] || [mode.vehicle isEqualToString:@"MEDIUMTRUCK"]) {
                    _serviceHeight = 5;
                    
                }
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:carFleetVC animated:YES];
        }
        
    }else if (indexPath.section == 7) {
        
        [self tapAvatarView];
        
    }
    
    
}

- (void)clickServiceBtnTip{
    
    NSString *tipStr = [NSString stringWithFormat:@"%@，没有此项服务",_carTypeName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipStr preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)getDataFromConfirmButtonClick:(NSString *)selectDate{
    
    _time = selectDate;
    
    [self clickLookForCarSureButtonHttp];
    
    
    
    
}
// 选择地图位置回调－－－赋值
- (void)didSelectAddress:(NSString *)address poi:(NSString *)poi location:(CLLocationCoordinate2D )location
{
    
    [self.PlaceArr replaceObjectAtIndex:self.indexNumber.row withObject:address];
    [self.PlaceAdressArr replaceObjectAtIndex:self.indexNumber.row withObject:poi];
    [self.LatitudeArr replaceObjectAtIndex:self.indexNumber.row withObject:[NSString stringWithFormat:@"%f",location.latitude]];
    [self.LongitudeArr replaceObjectAtIndex:self.indexNumber.row withObject:[NSString stringWithFormat:@"%f",location.longitude]];
    if (self.PlaceAdressArr.count >= 2) {
        [self acculuDistance];
    }
    [self.tableView reloadData];
}
//选择地图位置回调 －－ 获取城市
- (void)cityWideForDayAndHalfDay:(NSString *)city{
    
    [self.cityArr replaceObjectAtIndex:self.indexNumber.row withObject:city];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.headerView removeFromSuperview];
    [self.clealView removeFromSuperview];
    
    
    
    [self.platformBidView removeFromSuperview];
    [self.platformView removeFromSuperview];
    
    
    
}




//包半日或者包全日按钮
-(void)CharteredBusTime_day:(UIButton *)button
{
    NSArray *arrCity = self.cityArr;
    NSSet *set =[NSSet setWithArray:arrCity];
    if (set.count != 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"非同城不提供包车服务" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (button.tag == 2) {
        button.selected = !button.selected;
        if (button.selected ) {
            self.dayButton.selected = NO;
            _isHalfOfDay = YES;
            _isOneOfDay = NO;
            
        }else{
            
            _isOneOfDay = NO;
            _isHalfOfDay = NO;
            
        }
        
    }else{
        button.selected = !button.selected;
        if (button.selected ) {
            self.halfOfDayButton.selected = NO;
            _isOneOfDay = YES;
            _isHalfOfDay = NO;
            
        }else{
            
            _isOneOfDay = NO;
            _isHalfOfDay = NO;
            
        }
        
    }
    [self senderHttpReque];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}




- (void)acculuDistance{
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    CGFloat lat = [self.LatitudeArr.firstObject doubleValue];
    CGFloat lng = [self.LongitudeArr.firstObject doubleValue];
    start.pt = (CLLocationCoordinate2D){lat, lng};
    
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    CGFloat lat2 = [self.LatitudeArr.lastObject doubleValue];
    CGFloat lng2 = [self.LongitudeArr.lastObject doubleValue];
    end.pt = (CLLocationCoordinate2D){lat2, lng2};
    
    //    NSMutableArray *centerLatitudeArr = [NSMutableArray array];
    //    [centerLatitudeArr addObject:self.LatitudeArr];
    
    //    NSMutableArray *centerLongitudeArr = [NSMutableArray array];
    //    [centerLongitudeArr addObjectsFromArray:self.LongitudeArr];
    //
    //    [centerLatitudeArr removeObjectAtIndex:0];
    //    [centerLatitudeArr removeLastObject];
    //
    //    [centerLongitudeArr removeLastObject];
    //    [centerLongitudeArr removeObjectAtIndex:0];
    
    
    NSMutableArray *centerData = [NSMutableArray array];
    
    for (int i =0; i < self.LongitudeArr.count; i++) {
        //
        //        AMapNaviPoint *centerpoint = [AMapNaviPoint locationWithLatitude:[self.LatitudeArr[i] doubleValue] longitude:[self.LongitudeArr[i] doubleValue]];
        BMKPlanNode *wayPointItem = [[BMKPlanNode alloc]init];
        
        wayPointItem.pt = CLLocationCoordinate2DMake([self.LatitudeArr[i] doubleValue], [self.LongitudeArr[i] doubleValue]);
        [centerData addObject:wayPointItem];
    }
    
    //    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
    
    //    [array addObject:wayPointItem1];
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.wayPointsArray = centerData;
    drivingRouteSearchOption.drivingPolicy = BMK_DRIVING_BLK_FIRST;//避免拥堵
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"search success.");
    }
    else
    {
        NSLog(@"search failed!");
    }
    
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
    if (result != nil) {
        NSArray *arrRoute = result.routes;
        BMKDrivingRouteLine *line = arrRoute[0];
        self.savedistance =line.distance/1000;
        //显示路径或开启导航
        _routesearch.delegate = nil;

        [self senderHttpReque];
        
    }
}

- (void)judgeWhitchServiceBtnNeedTip{
    
    NSString *pagStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pageControlPage"];
    if ([pagStr isEqualToString:@"0"]) {
        _serviceHeight = 4;
    }else if ([pagStr isEqualToString:@"1"]) {
        _serviceHeight = 4;
    }else if ([pagStr isEqualToString:@"2"]) {
        _serviceHeight = 4;
    }else if ([pagStr isEqualToString:@"6"]) {
        _serviceHeight = 4;
    }else{
        _serviceHeight = 5;
    }
    //判断我的车队里的车型服务
    if (_vechileTeamArr.count > 0) {
        DriverInfoMode *mode = _vechileTeamArr[0];
        if ([mode.vehicle isEqualToString:@"MINITRUCK"] || [mode.vehicle isEqualToString:@"SMALLTRUCK"] || [mode.vehicle isEqualToString:@"MEDIUMTRUCK"]) {
            _serviceHeight = 5;
        }else{
            _serviceHeight = 4;
        }
    }else{
        
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
//根据参数随时进行估价
-(void)senderHttpReque
{
    
    NSArray *arr = @[@"MINIVAN",@"LARGEVAN",@"IVECO",@"MINITRUCK",@"SMALLTRUCK",@"MEDIUMTRUCK",@"FLATBED"];
    //服务项目
    
    
    NSString *day =@"";
    
    
    if (_isHalfOfDay) {
        
        day = @"1";
        
        
    }else if (_isOneOfDay){
        
        day = @"2";
    }else{
        
        day = @"";
        
    }
    
    NSString *pagStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pageControlPage"];
    
    
    NSLog(@"page====gggggggg==%@",pagStr);
    
    
    NSString *carType = arr[[pagStr integerValue]];
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/evaluateReq"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"mileage":@(_savedistance),@"vehicleType":carType,@"days":day,@"service":@"7"} success:^(id responseObj) {
        
        _evaluateMoney =[NSString stringWithFormat:@"%.0f",[[responseObj objectForKey:@"evaluate"] floatValue]];
        
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:6];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
}

//找车确定按钮
-(void)clickLookForCarSureButtonHttp
{
    
    
    //服务项目
    NSString *AllserveStr =[self.allSeletedService componentsJoinedByString:@","];
    
    NSString *day =@"";
    
    if (_isHalfOfDay) {
        
        day = @"1";
        
        
    }else if (_isOneOfDay){
        
        day = @"2";
        
    }else{
        
        day = @"";
        
        
    }
    NSArray *arr = @[@"MINIVAN",@"LARGEVAN",@"IVECO",@"MINITRUCK",@"SMALLTRUCK",@"MEDIUMTRUCK",@"FLATBED"];
    
    
    //结束的主位置
    NSMutableArray *endCityArr = [NSMutableArray array];
    [endCityArr addObjectsFromArray:self.PlaceArr];
    [endCityArr removeObjectAtIndex:0];
    NSString *endCityStr = [[endCityArr componentsJoinedByString:@","] stringByAppendingString:@","];
    
    
    //结束的详细信息
    
    NSMutableArray *endAdressCityArr = [NSMutableArray array];
    [endAdressCityArr addObjectsFromArray:self.PlaceAdressArr];
    [endAdressCityArr removeObjectAtIndex:0];
    
    NSString *endCityAdressStr = [[endAdressCityArr componentsJoinedByString:@","] stringByAppendingString:@","];
    
    
    //结束的LaLatitude
    NSMutableArray *endLatitudeArr = [NSMutableArray array];
    [endLatitudeArr addObjectsFromArray:self.LatitudeArr];
    [endLatitudeArr removeObjectAtIndex:0];
    NSString *endLatitudeStr = [[endLatitudeArr componentsJoinedByString:@","] stringByAppendingString:@","];
    
    //结束的Longitude
    
    NSMutableArray *endLongitudeArr = [NSMutableArray array];
    [endLongitudeArr addObjectsFromArray:self.LongitudeArr];
    [endLongitudeArr removeObjectAtIndex:0];
    NSString *endLongitudeArrStr = [[endLongitudeArr componentsJoinedByString:@","] stringByAppendingString:@","];
    
    
    
    NSString *phoneNumber = userPhone;
    NSString *pagStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pageControlPage"];
    
    NSString *vehicle = arr[[pagStr integerValue]];
    if (_vechileTeamArr.count > 0) {
        DriverInfoMode *mode = _teamDrMode;
        vehicle = mode.vehicle;
    }
    
    if (_linkPhone.length <= 0) {
        _linkPhone = _placeholderPhone;
    }
    if (_linkName.length <= 0) {
        _linkName = _placeholderName;
    }
    //代收货款
    NSInteger isLieu;
    if (_PaymentNum == 2) {
        isLieu = 1;
        
    }else{
        isLieu = 0;
    }
    NSInteger isAuth;
    if (_authentication) {
        isAuth = 1;
    }else{
        isAuth = 0;
    }
    if (_vechileTeamArr.count > 0) {
        DriverInfoMode *model = _vechileTeamArr[0];
        vehicle = model.vehicle;
    }
    NSDictionary *dic = @{@"departTime":_time ,@"departPlace":self.PlaceAdressArr.firstObject,@"arrivePlace":endCityAdressStr,@"latitude":self.LatitudeArr.firstObject,@"longitude":self.LongitudeArr.firstObject,@"vehicle":vehicle,@"service":AllserveStr,@"days":day,@"contacts":_linkName,@"phone":_linkPhone,@"city":self.PlaceArr.firstObject,@"district":endCityStr,@"remark":@"",@"evaluate":_evaluateMoney,@"bid":_giveMoneyPhone,@"reqName":phoneNumber,@"reqApplicant":phoneNumber,@"endLatitude":endLatitudeStr,@"endLongitude":endLongitudeArrStr,@"timeType":@(_timeType),@"isLieu":@(isLieu),@"lieuAmount":_money,@"isAuthentication":@(isAuth)};
    
    NSString *str = [self dictionaryToJson:dic];
    
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/saveCharteredReq"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"charteredReq":str} success:^(id responseObj) {
        
          _sureBtn.enabled = YES;
        if ([[responseObj objectForKey:@"Message"] isEqualToString:@"1"]) {
            //开启定时器
            
            [MBProgressHUD showError:@"下单失败"];
        }else{
            
            NSString *orderNo = [responseObj objectForKey:@"Message"];
            lookForDriverMapController *lookForDriverVC = [[lookForDriverMapController alloc]init];
            lookForDriverVC.orderNunber = orderNo;
            [self.navigationController pushViewController:lookForDriverVC animated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
          _sureBtn.enabled = YES;
        [MBProgressHUD showError:@"网络异常"];
    }];
    
    
}
-(void)switchAction:(UISwitch*)sender
{
    if (sender.tag == 321) {
        if (sender.on) {
            NSLog(@"开");
            _PaymentNum = 2;
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:4];
            [indexPaths addObject: indexPath];
            
        }else {
            
            NSLog(@"关");
            _PaymentNum = 1;
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:4];
            [indexPaths addObject: indexPath];
            
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }else if (sender.tag ==335){
        
        if (sender.on) {
            _authentication = YES;
        }else{
            _authentication = NO;
        }
    }
    
}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField becomeFirstResponder];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 10003){
        
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
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//    [textField resignFirstResponder];
//    //清空transform，以前的平移、缩放、旋转都会消失
//    [UIView animateWithDuration:0.5 animations:^{
//        self.view.transform = CGAffineTransformIdentity;
//    }];
//    if ([_evaluateMoney isEqualToString:@"暂无"]) {
//        [MBProgressHUD showSuccess:@"出价不能低于平台价格"];
//
//    }
//
//    
//    return YES;
//}

- (void)backgroundhome:(NSNotification *)notification{
    [self.view endEditing:YES];
    self.view.transform = CGAffineTransformIdentity;
    
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, - 200 * HOR_SCALE);
    }];
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        
    }];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
