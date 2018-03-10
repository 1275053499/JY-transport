//
//  JYBaseOrderViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYBaseOrderViewController.h"
#import "JYHomePageTableViewCell.h"
#import "JYOrderDetailViewController.h"
#import "JYMessageRequestData.h"
#import "JYMessageModel.h"
#import "JYWaitingAnimationViewController.h"
@interface JYBaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)NSTimer *timerBase;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger statusPage;

@end

@implementation JYBaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _statusPage = 0;
    self.view.backgroundColor = BgColorOfUIView;
    self.dataArr = [NSMutableArray array];

    [self creatTableView];

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setupRefreshView];

    _statusPage = self.index;
}

-(void)setupRefreshView
{

    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf loadNewData:_statusPage page:1];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //下拉加载更多数据
      self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page ++;
        [weakSelf loadNewData:_statusPage page:weakSelf.page];
        
    }];
}

//下拉刷新数据
-(void)loadNewData:(NSInteger)index page:(NSInteger)page
{

    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate  = self;
    index = index + 1;//后台从1开始的
    [manager requsetGetOrderToLogistics:@"app/logisticsorder/getOrderToUser" phone:userPhone statusPage:index page:page];
    
}

- (void)requestGetOrderToLogisticsSuccess:(NSDictionary *)resultDic{
    

    if (_page == 1) {
        
        self.dataArr = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView.mj_footer endRefreshing];

    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [JYMessageModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.dataArr addObjectsFromArray:dataArr];
        
        if (dataArr.count < 10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];

        }

    }
    
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];



}
- (void)requestGetOrderToLogisticsFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


    
}
//上拉加载旧数据
-(void)getMoreData:(NSInteger)index
{
   
    
}
//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49 - 60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.rowHeight = 156;
    
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    JYHomePageTableViewCell *cell = [JYHomePageTableViewCell cellWithOrderTableView:tableView];
    cell.messageModel = self.dataArr[indexPath.section];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 9;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JYMessageModel *messageModel = self.dataArr[indexPath.section];
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

//    ModelOrder *orderModel = self.statusFrames[indexPath.section];
//    orederVC.OrderModel= orderModel;
//    
//    
    
    
}
-(void)dealloc{
    
    
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end

