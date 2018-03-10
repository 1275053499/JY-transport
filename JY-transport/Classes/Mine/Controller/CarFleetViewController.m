//
//  CarFleetViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CarFleetViewController.h"
#import "CarFleetCell.h"
#import "CarTeamMode.h"
#import "DriverInfoMode.h"
#import "AddCarViewController.h"
#import "LookForCarViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "NearbyVehiclesVC.h"
@interface CarFleetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *carTeamInfoArr;//我的车队数据
@property (nonatomic,strong)NSString *carID;//取消收藏 id
@property (nonatomic,assign)int selectIndex;
@property (nonatomic,strong)CarTeamMode *model;

@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,strong)NSMutableArray *addressArr;//逆地理
@property (nonatomic,strong)NSMutableArray *infoNameArr;//逆地理
@end

@implementation CarFleetViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"车队";
    _selectIndex = 0;
    self.view.backgroundColor = BgColorOfUIView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    _infoNameArr = [NSMutableArray array];
    _addressArr = [NSMutableArray array];
    
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加车辆" style:UIBarButtonItemStylePlain target:self action:@selector(addCarClick)];
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    //    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self createTableView];
    self.carTeamInfoArr = [NSMutableArray array];
    
    [self creatRightBtn];
    
    
}
- (void)creatRightBtn{
    //    UIView *BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 35)];
    //
    //
    //    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addBtn.frame = CGRectMake(75, 0, 45, 35);
    //    [addBtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:(UIControlStateNormal)];
    //    [addBtn addTarget:self action:@selector(addCarClick) forControlEvents:UIControlEventTouchUpInside];
    //    addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -13);
    //
    //    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    deleteBtn.frame = CGRectMake(0, 0, 75, 35);
    //    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    //    [deleteBtn setTitle:@"附近" forState:(UIControlStateNormal)];
    //    [deleteBtn addTarget:self action:@selector(nearByBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    addBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    //    [BottomView addSubview:deleteBtn];
    //    [BottomView addSubview:addBtn];
    //    //添加到导航条
    //    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:BottomView];
    //
    //    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithIconAndTitle:@"附近" target:self firstAction:@selector(nearByBtnClick) icon:@"icon_tianjia" highIcon:@"icon_tianjia" secondAction:@selector(addCarClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    if ([self.pushFromVC isEqualToString:@"LookForCarViewController"]) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    
}
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight);
}


- (void)nearByBtnClick{
    
    
    NearbyVehiclesVC *nearVC = [[NearbyVehiclesVC alloc] init];
    [self.navigationController pushViewController:nearVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //刷新UI
    //
    //        [MBProgressHUD showActivityMessageInView:@"请稍等..."];
    //
    //    });
    //    if ([self.pushFromVC isEqualToString:@"MineViewController"]) {
    //        [self loadNewData];
    //    }if ([self.pushFromVC isEqualToString:@"LookForCarViewController"]) {
    //        [self loadNewDataForLookCarVC];
    //    }
    //
    //
    __weak __typeof(self) weakSelf = self;
    //下拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}
//- (void)tableviewReloadDate{
//
//    [MBProgressHUD hideHUD];
//}


//拨打电话
- (void)callClick:(UIButton *)btn{
    CarTeamMode *mode = self.carTeamInfoArr[btn.tag];
    
    
    NSMutableString* callPhone=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mode.truckGoup.phone];
    
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)lookForCarButtonClick:(UIButton *)btn{
    
    CarTeamMode *mode = self.carTeamInfoArr[btn.tag];
    
    LookForCarViewController *lookVC = [[LookForCarViewController alloc] init];
    lookVC.teamDrMode = mode.truckGoup;
    [self.navigationController pushViewController:lookVC animated:YES];
    
}
- (void)addCarClick{
    AddCarViewController *addCar = [[AddCarViewController alloc] init];
    [self.navigationController pushViewController:addCar animated:YES];
    
    
}
//根据中文车型 找到 英文
//- (void)judgeVechileisTypeEnglish{
//    if ([self.vechileTypeStr isEqualToString:@"微面"]) {
//        self.vechileTypeStr = @"MINIVAN";
//    }else if ([self.vechileTypeStr isEqualToString:@"大型面包车"]){
//        self.vechileTypeStr = @"LARGEVAN";
//    }else if ([self.vechileTypeStr isEqualToString:@"依维柯"]){
//        self.vechileTypeStr = @"IVECO";
//    }else if ([self.vechileTypeStr isEqualToString:@"微型货车"]){
//        self.vechileTypeStr = @"MINITRUCK";
//    }else if ([self.vechileTypeStr isEqualToString:@"小型货车"]){
//        self.vechileTypeStr = @"SMALLTRUCK";
//    }else if ([self.vechileTypeStr isEqualToString:@"中型货车"]){
//        self.vechileTypeStr = @"MEDIUMTRUCK";
//    }else if ([self.vechileTypeStr isEqualToString:@"平板车"]){
//        self.vechileTypeStr = @"FLATBED";
//    }
//}
//下拉刷新数据
-(void)loadNewDataForLookCarVC
{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/getTruckListBV"];
    _page = 1;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":userPhone,@"page":@"1",@"vechileType":@""} success:^(id responseObj) {
        self.carTeamInfoArr = [CarTeamMode mj_objectArrayWithKeyValuesArray:responseObj];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.carTeamInfoArr == nil || self.carTeamInfoArr.count == 0) {
            [MBProgressHUD showError:@"您还没有收藏此车型"];
        }
        if (self.carTeamInfoArr.count <10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

//下拉刷新数据
-(void)loadNewData
{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/getMyTruckList"];
    _page = 1;
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":userPhone,@"page":@"1"} success:^(id responseObj) {
        self.carTeamInfoArr = [CarTeamMode mj_objectArrayWithKeyValuesArray:responseObj];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.carTeamInfoArr == nil || self.carTeamInfoArr.count == 0) {
            [MBProgressHUD showError:@"您还没有收藏"];
        }
        if (self.carTeamInfoArr.count <10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.geoCodeSearch.delegate = nil;
    self.geoCodeSearch = nil;
    
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight =165;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carTeamInfoArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = BgColorOfUIView;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        
        return 9;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarFleetCell *cell = [CarFleetCell cellWithTableView:tableView];
    
    self.model =  self.carTeamInfoArr[indexPath.section];
    cell.carMode = self.model;
    cell.callPhoneButton.tag = indexPath.section;
    cell.lookForCarButton.tag = indexPath.section;
    _carID =cell.carMode.ID;
    [cell.callPhoneButton addTarget:self action:@selector(callClick:)forControlEvents:(UIControlEventTouchUpInside)];
    [cell.lookForCarButton addTarget:self action:@selector(lookForCarButtonClick:)forControlEvents:(UIControlEventTouchUpInside)];
    
    if ([self.pushFromVC isEqualToString:@"LookForCarViewController"]) {
        cell.lookForCarButton.hidden = YES;
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarFleetCell *cell = [CarFleetCell cellWithTableView:tableView];
    
    cell.carMode = self.carTeamInfoArr[indexPath.section];
    _carID = cell.carMode.ID;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectIndex = (int)indexPath.section;
    if ([self.pushFromVC isEqualToString:@"MineViewController"]) {
        UIAlertView *WXinstall=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您要取消收藏吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//一般在if判断中加入
        [WXinstall show];
        
    }if ([self.pushFromVC isEqualToString:@"LookForCarViewController"]) {
        if (_passOnName) {
            CarTeamMode *carMode =self.carTeamInfoArr[indexPath.section];
            DriverInfoMode *mod = carMode.truckGoup;
            _passOnName(mod);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"取消"]) {
        NSLog(@"你点击了取消");
    }else if ([btnTitle isEqualToString:@"确定"] ) {
        NSLog(@"你点击了确定");
        [self cancelCollection];
        
    }
}

//取消收藏
- (void)cancelCollection{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/calMTCollection"];
    _page = 1;
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":_carID,} success:^(id responseObj) {
        
        if ([responseObj objectForKey:@"message"]) {
            if ([responseObj[@"message"]isEqualToString:@"0"]) {
                
                [self.carTeamInfoArr removeObjectAtIndex:_selectIndex];
                
                [_tableView reloadData];
                
            }
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}

@end
