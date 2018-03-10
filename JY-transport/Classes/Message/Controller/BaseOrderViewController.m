//
//  BaseOrderViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseOrderViewController.h"
#import "OrderModel.h"
#import "OrderTableViewCell.h"
#import "orderDetailViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "JYMessageRequestData.h"
#import "JYMessageRequestData.h"
#import "JYMessageModel.h"
#import "JYHomePageTableViewCell.h"
#import "JYWaitingAnimationViewController.h"
#import "JYOrderDetailViewController.h"
#import "EmptyTableView.h"
@interface BaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>

@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,strong)EmptyTableView *tableView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger segmentIndex;

@end

@implementation BaseOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusFrames = [NSMutableArray array];
    _page = 1;
    _segmentIndex = 0;
    self.view.backgroundColor = BgColorOfUIView;
    [self creatTableView];
    self.tableView.rowHeight =188;
    [self setupRefreshView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSetupRefreshView:) name:@"orderCancelSuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"evaluateSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView) name:@"OrderMoneyDidGive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationdidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeg:) name:UIApplicationWillEnterForegroundNotification object:nil];
    //没有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkReachabilityStatusUnknown) name:@"noWork" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upData) name:@"getDrivers" object:nil];//司机抢单  需要刷新订单状态
    
    
        
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseOrderType:) name:@"chooseOrderType" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"segmentIndex"];

    if (_index == 1) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getByConditionUser:) name:@"getByConditionUser" object:nil];
    }
    
}
- (void)getByConditionUser:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    NSString *orderNo = [userInfo objectForKey:@"orderNo"];
    NSString *service = [userInfo objectForKey:@"service"];
    NSString *startDate = [userInfo objectForKey:@"startDate"];
    NSString *endDate = [userInfo objectForKey:@"endDate"];
    
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getByConditionUser"];
    
    if (startDate == nil || [startDate isEqual:[NSNull null]]) {
        startDate = @"";
    }else if (endDate == nil || [endDate isEqual:[NSNull null]])  {
        endDate = @"";
    }
    NSDictionary *dic = @{@"orderNo":orderNo,
                          @"service":service,
                          @"startDate":startDate,
                          @"endDate":endDate,
                          @"phone":phoneNumber
                          };
  
    [[NetWorkHelper shareInstance]Post:urlStr parameter:dic success:^(id responseObj) {
       
        
        NSMutableArray *inquireArr = [OrderModel mj_objectArrayWithKeyValuesArray:responseObj];
        [self.tableView reloadData];
           
        }failure:^(NSError *error) {
        
        
    }];
    
}

//- (void)chooseOrderType:(NSNotification *)noti{
//
//    NSDictionary *user = noti.userInfo;
//    NSNumber *segmentNum = [user objectForKey:@"segmentIndex"];
//    _segmentIndex = [segmentNum intValue];
//    NSInteger index = [[user objectForKey:@"index"] integerValue];
//
//    [[NSUserDefaults standardUserDefaults] setObject:@(_segmentIndex) forKey:@"segmentIndex"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"找车发货%ld------类型%ld",_segmentIndex,index);
//
//    [self setupRefreshView:index];
//
//
//}

- (void)NetworkReachabilityStatusUnknown{
    
    [self.tableView.mj_header endRefreshing];
}
- (void)cancelSetupRefreshView:(NSNotification *)noti{
    
    [self loadNewData:2];

}
-(void)setupRefreshView
{

//    if ([self.tableView.mj_header isRefreshing]) {
//        return;
//    }
     __weak __typeof(self) weakSelf = self;
    
    //上拉刷新新数据
    // 声明局部变量global
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
//        if (weakSelf.segmentIndex == 0) {
            [weakSelf loadNewData:self.index];

//        }else if (weakSelf.segmentIndex == 1){
//            [weakSelf loadNewDataForLogistic:index page:weakSelf.page];
//        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
    

    //下拉加载更多数据
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

//        if (weakSelf.segmentIndex == 0) {
            [weakSelf getMoreData];

//        }else if (weakSelf.segmentIndex == 1){
//
//            [weakSelf loadNewDataForLogistic:index page:weakSelf.page];
//        }
        
     }]; 
}
//前台
- (void)applicationWillEnterForeg:(NSNotification *)nottfication{
    
     [self loadNewData:self.index];

}
//退到后台
- (void)applicationdidEnterBackground:(NSNotification *)nottfication{
   
    
}
//- (void)noNetWorkTip{
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您现在没有可用网络" preferredStyle: UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
//
//}
//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
//    NSNumber *segNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"segmentIndex"];
//    _segmentIndex = [segNum integerValue];
    
    [self loadNewData:self.index];
    
 
//    [self setupRefreshView:self.index];

    
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    
}
- (void)upData{
    
    [self loadNewData:self.index];
    
}

//下拉刷新数据
-(void)loadNewData:(NSInteger)index
{
    _page = 1;
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    NSArray *catagoryArr = @[@"2",@"4",@"5"];
    NSString *currentCategory = [catagoryArr objectAtIndex:index];
    NSInteger statusPage = [currentCategory integerValue];
    [manager requsetGetOrderToLogistics:@"app/chartered/getOrderByUser?" phone:userPhone statusPage:statusPage page:_page];
    
}
- (void)requestGetOrderToLogisticsSuccess:(NSDictionary *)resultDic{
    
    
        [self.tableView.mj_footer resetNoMoreData];
        [self.statusFrames removeAllObjects];
    
        if (_segmentIndex == 0) {
            
            self.statusFrames = [OrderModel mj_objectArrayWithKeyValuesArray:resultDic];

        }else{
            
//            self.statusFrames = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];

        }

    [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.statusFrames.count frame:self.tableView.frame];
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];

}
- (void)requestGetOrderToLogisticsFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}

//上拉加载旧数据
-(void)getMoreData
{
    _page ++;
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getOrderByUser?"];
    NSArray *catagoryArr = @[@"2",@"4",@"5"];
    NSString *currentCategory = [catagoryArr objectAtIndex:self.index];
    NSInteger statusPage = [currentCategory integerValue];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"status":@(statusPage),@"page":@(_page)} success:^(id responseObj) {
       
        if (_segmentIndex == 0) {
            if([responseObj isKindOfClass:[NSDictionary class]]){
                if ( [[responseObj objectForKey:@"message"] isEqualToString:@"404"]) {
                    
                    [MBProgressHUD showError:@"暂无更多数据"];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                
            }else{
                
                NSMutableArray *dataArr = [NSMutableArray array];
                dataArr = [OrderModel mj_objectArrayWithKeyValuesArray:responseObj];
                [self.statusFrames addObjectsFromArray:dataArr];
             
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                
            }
        }else{
            //
            //            NSMutableArray *dataArr = [NSMutableArray array];
            //                dataArr = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];
            //                [self.statusFrames addObjectsFromArray:dataArr];
            //
            //                if (dataArr.count < 10) {
            //
            //                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
            //                }else{
            //
            //                    [self.tableView.mj_footer endRefreshing];
            //
            //                }
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
}


//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[EmptyTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-40 - NavigationBarHeight - StateBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 9;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    

    return self.statusFrames.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentIndex == 0) {
        
        OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView];
        cell.model = self.statusFrames[indexPath.section];
        
        return cell;
        
    }else{
       
        JYHomePageTableViewCell *cell = [JYHomePageTableViewCell cellWithOrderTableView:tableView];
        cell.messageModel = self.statusFrames[indexPath.section];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        
        return 9;

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segmentIndex == 0) {
        
        orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
        
        OrderModel *orderModel = self.statusFrames[indexPath.section];
        orederVC.OrderModel= orderModel;
        
        
        [self.navigationController pushViewController:orederVC animated:YES];
        
    }else{
        
        [self didselectRowForSegmentLogistic:indexPath];
    }
  
    
}
- (void)didselectRowForSegmentLogistic:(NSIndexPath *)indexPath{
    JYMessageModel *messageModel = self.statusFrames[indexPath.section];
    JYWaitingAnimationViewController *animationVC = [[JYWaitingAnimationViewController alloc] init];
    animationVC.orderID = messageModel.id;
    animationVC.startProvice = messageModel.originatingSite;
    animationVC.endProvice = messageModel.destination;
    
    
    if ([messageModel.orderStatus isEqualToString:@"0"] || [messageModel.orderStatus isEqualToString:@"1"]) {
        
        if ([messageModel.orderType isEqualToString:@"1"]) {
            
            animationVC.orderDetailType = @"animation";
            [self.navigationController pushViewController:animationVC animated:YES];\
        }else{
            JYOrderDetailViewController *orederVC = [[JYOrderDetailViewController alloc]init];
            orederVC.orderID = messageModel.id;
            orederVC.orderStatus = messageModel.orderStatus;
            [self.navigationController pushViewController:orederVC animated:YES];
        }
        
    }else if ([messageModel.orderStatus isEqualToString:@"2"]){
        
        animationVC.orderDetailType = @"SurePrice";
        
        [self.navigationController pushViewController:animationVC animated:YES];
        
    }else if ([messageModel.orderStatus isEqualToString:@"7"]){
        
        animationVC.orderDetailType = @"SureOrder";
        
        [self.navigationController pushViewController:animationVC animated:YES];
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        JYOrderDetailViewController *orederVC = [[JYOrderDetailViewController alloc]init];
        orederVC.orderID = messageModel.id;
        orederVC.orderStatus = messageModel.orderStatus;
        [self.navigationController pushViewController:orederVC animated:YES];
        
        
    }else {
        
        JYOrderDetailViewController *orederVC = [[JYOrderDetailViewController alloc]init];
        orederVC.orderID = messageModel.id;
        orederVC.orderStatus = messageModel.orderStatus;
        
        [self.navigationController pushViewController:orederVC animated:YES];
        
    }
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}


#pragma mark ======== segment发货 =========
//下拉刷新数据
//-(void)loadNewDataForLogistic:(NSInteger)index page:(NSInteger)page
//{
//
//    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
//    manager.delegate  = self;
//    index = index + 1;//后台从1开始的
//    [manager requsetGetOrderToLogistics:@"app/logisticsorder/getOrderToUser" phone:userPhone statusPage:index page:page];
//
//}


@end
