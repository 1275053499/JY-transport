//
//  NearbyLogisticsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/11/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "NearbyLogisticsViewController.h"
#import "JYConfirmTableViewCellSecond.h"
#import "JYConfirmTableViewCellThird.h"
#import "JYLookEvaluateViewController.h"
#import "JYLookCompanyViewController.h"
#import "JYLookOutletsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MineRequestData.h"
#import "JYCompanyModel.h"
#import "MyLogisticsTableViewCell.h"
#import "PSCityPickerView.h"
#import "TMRouteInquiryController.h"
@interface NearbyLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MineRequestDataDelegate,PSCityPickerViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) CLLocationManager *LocationManager;// 设置位置管理者属性
@property (nonatomic,assign)CLLocationCoordinate2D location;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *logisticesArr;


@property (nonatomic,strong)PSCityPickerView *cityPicker;
@property (nonatomic,strong)NSString *addressChoose;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *district;
@property (nonatomic,strong)UIButton *chooseBtn;
@property (nonatomic,strong)UIButton *nearBtn;

@end@implementation NearbyLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.title = @"附近物流";
    _addressChoose = @"";
    _province = @"";
    _city = @"";
    _district = @"";
    [self createTableView];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,49, ScreenWidth, ScreenHeight - 64 - 49 - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self creatChooseBtn];

}

- (void)creatChooseBtn{
    UIButton *chooseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [chooseBtn setTitle:@"区 域" forState:(UIControlStateNormal)];
    chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 49);
    chooseBtn.backgroundColor = [UIColor whiteColor];
    chooseBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:17];
    [chooseBtn setTitleColor:RGB(153, 153, 153) forState:(UIControlStateNormal)];
    [chooseBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    
    [chooseBtn addTarget:self action:@selector(chooseAddressForLogistics:) forControlEvents:(UIControlEventTouchUpInside)];
    _chooseBtn = chooseBtn;
    [self.view addSubview:chooseBtn];
    
    
    UIButton *nearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [nearBtn setTitle:@"线路查询" forState:(UIControlStateNormal)];
    nearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nearBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 49);
    nearBtn.backgroundColor = [UIColor whiteColor];
    nearBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:17];
    [nearBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    [nearBtn setTitleColor:RGB(153, 153, 153) forState:(UIControlStateNormal)];
    
    [nearBtn addTarget:self action:@selector(nearLogisticsClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _nearBtn = nearBtn;
    nearBtn.selected = YES;
    [self.view addSubview:nearBtn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, 1, 22)];
    view.backgroundColor = RGB(238, 238, 238);
    view.centerY = _nearBtn.centerY;
    [_nearBtn addSubview:view];
    
    
}
- (void)nearLogisticsClick:(UIButton *)btn{
//    btn.selected = YES;
//    _chooseBtn.selected = NO;
//    [self setupRefreshView];
    TMRouteInquiryController *vc = [[TMRouteInquiryController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)LineInquiry{
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRefreshView];
    
}
-(void)setupRefreshView
{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    // 声明局部变量global
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [self getLocation];
        [weakSelf getMoreNearbyLogistices:weakSelf.page];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
//    __block int page = 1;
//    //下拉加载更多数据
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//        page ++;
//        weakSelf.page = page;
//        [weakSelf getMoreNearbyLogistices:weakSelf.page];
//    }];

}
- (void)getLocation{
    
    // 判断是否打开了位置服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 创建位置管理者对象
        self.LocationManager = [[CLLocationManager alloc] init];
        self.LocationManager.delegate = self; // 设置代理
        // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        self.LocationManager.distanceFilter = 10;
        self.LocationManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度(精度越高越耗电)
        [self.LocationManager startUpdatingLocation]; // 开始更新位置
    }
}

/** 获取到新的位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"定位到了");
    CLLocation *location = [locations lastObject];
    _location = location.coordinate;
    
    if (locations != nil && locations.count > 0) {
        [self.LocationManager stopUpdatingLocation];
        [self getMoreNearbyLogistices:1];

    }
}

/** 不能获取位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"获取定位失败");
}
- (void)getMoreNearbyLogistices:(NSInteger)page{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    manager.delegate = self;
    [manager requestNearbyLogistices:@"app/user/getNearLogisticGroup" location:_location page:_page];
    
}

- (void)requestNearbyLogisticesSuccess:(id)resultDic{
    
    if (_page == 1) {
        
        self.logisticesArr = [JYCompanyModel mj_objectArrayWithKeyValuesArray:resultDic];
        
    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [JYCompanyModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.logisticesArr  addObjectsFromArray:dataArr];
        
        if (dataArr.count < 10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}



- (void)requestNearbyLogisticesFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logisticesArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    return 110;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MyLogisticsTableViewCell *cell = [MyLogisticsTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.comModel = self.logisticesArr[indexPath.section];
    
    [cell.evaluationBtn addTarget:self action:@selector(lookEvaluationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.IntroductionBtn addTarget:self action:@selector(lookCompanyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.outletsBtn addTarget:self action:@selector(lookOutletsBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.evaluationBtn.tag = 66 + indexPath.section;
    cell.IntroductionBtn.tag = 67 + indexPath.section;
    cell.outletsBtn.tag = 68 + indexPath.section;
  
    return cell;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 9;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentTipAlert:indexPath];
}

- (void)lookEvaluationBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.logisticesArr[btn.tag - 66];
    
    JYLookEvaluateViewController *vc = [[JYLookEvaluateViewController  alloc] init];
    vc.logisticsId = companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)lookCompanyBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.logisticesArr[btn.tag - 67];
    
    JYLookCompanyViewController *vc = [[JYLookCompanyViewController alloc] init];
    vc.introductions = companymodel.introductions;
    vc.icon = companymodel.icon;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lookOutletsBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.logisticesArr[btn.tag - 68];
    
    JYLookOutletsViewController *vc = [[JYLookOutletsViewController alloc] init];
    vc.logisticsid = companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//收藏物流公司
- (void)collectionLogistic:(NSString*)logisticsId{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    
    manager.delegate = self;
    [manager requestCollectionLogistices:@"app/myLogistics/addLogistics" phone:userPhone logisticsId:logisticsId];
    
    
}
- (void)requestCollectionLogisticesSuccess:(id)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    
    if ([message isEqualToString:@"0"]) {
        [MBProgressHUD showInfoMessage:@"收藏成功"];
    }else if ([message isEqualToString:@"410"]) {
        
        [MBProgressHUD showInfoMessage:@"您已经收藏过"];

    }
    
}
- (void)requestCollectionLogisticesFailed:(NSError *)error{
    
     [MBProgressHUD showInfoMessage:@"收藏错误"];
}





- (void)presentTipAlert:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您要添加收藏吗？" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        JYCompanyModel *companymodel = self.logisticesArr[indexPath.section];
        [self collectionLogistic:companymodel.id];

        
    }];
    //点击按钮的响应事件
    [alert addAction:cancel];
    
    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district ProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID
{
    if (city == nil  || province == nil) {
        city = @"北京";
        province = @"北京";
        district = @"东城区";
    }
    _province = province;
    _city = city;
    _district = district;
    
    _addressChoose = [NSString stringWithFormat:@"%@·%@",city,district];
    
    [self searchLogistic:province city:city district:district];
    [_chooseBtn setTitle:_addressChoose forState:(UIControlStateNormal)];
    
}

- (void)chooseAddressForLogistics:(UIButton *)btn{
    
    btn.selected = YES;
    _nearBtn.selected = NO;
    [self.cityPicker showPickView];
    if ([_chooseBtn.titleLabel.text isEqualToString:@"区 域"]) {
        
        self.logisticesArr = nil;
        [self.tableView reloadData];
    }else{
        [self searchLogistic:_province city:_city district:_district];
    }
    
}

/**
 搜索物流公司
 */
- (void)searchLogistic:(NSString *)provice city:(NSString *)city district:(NSString *)district{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    
    manager.delegate = self;
    [manager requestSearchLogistices:@"app/user/getLogisticGroupByRegion" province:provice city:city district:district];
    
}
- (void)requestSearchLogisticesSuccess:(id)resultDic{
    
    self.logisticesArr = [JYCompanyModel mj_objectArrayWithKeyValuesArray:resultDic];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
- (void)requestSearchLogisticesFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
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
