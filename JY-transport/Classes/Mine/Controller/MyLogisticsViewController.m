//
//  MyLogisticsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/11/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MyLogisticsViewController.h"
#import "JYLookEvaluateViewController.h"
#import "JYLookCompanyViewController.h"
#import "JYLookOutletsViewController.h"
#import "MineRequestData.h"
#import "LoginticModel.h"
#import "JYCompanyModel.h"
#import "NearbyLogisticsViewController.h"
#import "SearchLogisticsViewController.h"
#import "MyLogisticsTableViewCell.h"
@interface MyLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MineRequestDataDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *logisticesArr;


@end

@implementation MyLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.title = @"我的物流";
    _page = 1;
    [self creatRightBtn];
    _logisticesArr = [NSMutableArray array];
    [self createTableView];
}

- (void)creatRightBtn{
  
   
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithIconAndTitle:@"附近" target:self firstAction:@selector(nearLogistics) icon:@"icon_tianjia" highIcon:@"icon_tianjia" secondAction:@selector(addLogisticsClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)nearLogistics{
    NearbyLogisticsViewController *vc = [[NearbyLogisticsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addLogisticsClick{
    
    SearchLogisticsViewController *vc = [[SearchLogisticsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

        [weakSelf getMoreNearbyLogistices:weakSelf.page];

    }];
    
    [self.tableView.mj_header beginRefreshing];
    
//    __block int page = 1;
    //下拉加载更多数据
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//        page ++;
//        weakSelf.page = page;
//        [weakSelf getMoreNearbyLogistices:weakSelf.page];
//    }];
}


- (void)getMoreNearbyLogistices:(NSInteger)page{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    manager.delegate = self;

    [manager requestGetCollectionListForLogistices:@"app/myLogistics/getMyLogisticsList" phone:userPhone];
    
}

-(void)requestGetCollectionListForLogisticesSuccess:(id)resultDic{
    if (_page == 1) {
        
        self.logisticesArr = [LoginticModel mj_objectArrayWithKeyValuesArray:resultDic];
        
    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [LoginticModel mj_objectArrayWithKeyValuesArray:resultDic];
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
- (void)requestGetCollectionListForLogisticesFailed:(NSError *)error{
    
    NSData *dict = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
    
    NSString *string = [[NSString alloc] initWithData:dict encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);

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
    cell.model = self.logisticesArr[indexPath.section];

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
    LoginticModel *companymodel = self.logisticesArr[btn.tag - 66];
    
    JYLookEvaluateViewController *vc = [[JYLookEvaluateViewController  alloc] init];
    vc.logisticsId = companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)lookCompanyBtnClick:(UIButton *)btn{
    LoginticModel *companymodel = self.logisticesArr[btn.tag - 67];

    JYLookCompanyViewController *vc = [[JYLookCompanyViewController alloc] init];
    vc.introductions = companymodel.group.introductions;
    vc.icon = companymodel.group.icon;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lookOutletsBtnClick:(UIButton *)btn{
    LoginticModel *companymodel = self.logisticesArr[btn.tag - 68];

    JYLookOutletsViewController *vc = [[JYLookOutletsViewController alloc] init];
    vc.logisticsid = companymodel.group.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)cancelCollectionLogistic:(NSString *)myLogisticisId{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    manager.delegate = self;
    
    [manager requestCancelCollectionLogistices:@"app/myLogistics/cancleLogistics" logisticsId:myLogisticisId];
    
}
- (void)requestCancelCollectionLogisticesSuccess:(id)resultDic{
    
    [MBProgressHUD showInfoMessage:@"取消收藏成功"];

    [self getMoreNearbyLogistices:1];
    

}
- (void)requestCancelCollectionLogisticesFailed:(NSError *)error{
    
    
}
- (void)presentTipAlert:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您要取消收藏吗？" preferredStyle: UIAlertControllerStyleAlert];
   
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        LoginticModel *model = self.logisticesArr[indexPath.section];
        [self cancelCollectionLogistic:model.id];
        
    }];
    
    [cancel setValue:RGBA(0, 118, 255, 1) forKey:@"titleTextColor"];
    [action setValue:RGBA(0, 118, 255, 1) forKey:@"titleTextColor"];
    //点击按钮的响应事件
    [alert addAction:cancel];

    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
