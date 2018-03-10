//
//  JYLookEvaluateViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookEvaluateViewController.h"

#import "LookEvaluteTableViewCell.h"
#import "LookEvaluteTableViewCellOne.h"
#import "JYMessageRequestData.h"
#import "JYEvaluateModel.h"
@interface JYLookEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *evaluateDatas;
@property (nonatomic,strong)NSDictionary *dicData;
@property (nonatomic,assign)NSInteger page;

@end

@implementation JYLookEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _page = 1;

    _evaluateDatas = [NSMutableArray array];
    [self creatTableView];
    [self initRefresh];

}
- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 115.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    JYMessageRequestData *messageData = [[JYMessageRequestData alloc] init];
    messageData.delegate = self;
    if (self.logisticsId == nil || self.logisticsId.length <= 0 || [self.logisticsId isEqual:[NSNull null]]) {
        
    }else{
        
        [messageData  requGetSumByLogistics:@"app/logisticsevaluate/getSumByLogistics" logisticsId:self.logisticsId];
        
    }
}

- (void)initRefresh{
    
    __weak __typeof(self) weakSelf = self;
    //上拉刷新新数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requsetData:1];
    }];
    [self.tableView.mj_header beginRefreshing];
    //下拉加载更多数据
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        weakSelf.page ++;
        
        [weakSelf requsetData:weakSelf.page];
        
    }];
    
    
}

- (void)requsetData:(NSInteger)page{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    JYMessageRequestData *messageData = [[JYMessageRequestData alloc] init];
    messageData.delegate = self;
    if (self.logisticsId == nil || self.logisticsId.length <= 0 || [self.logisticsId isEqual:[NSNull null]]) {
        
    }else{
        
        [messageData  requGetEvaluateByLogistics:@"app/logisticsevaluate/getEvaluateByLogistics" logisticsId:self.logisticsId page:pageStr];
        
    }
    
       
}


//请求成功
- (void)requsetGetSumByLogisticsSuccess:(NSDictionary *)resultDic{
    
    self.dicData = resultDic;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

   
}
//请求失败
- (void)requsetGetSumByLogisticsFailed:(NSError *)error{
    

    
}


- (void)requGetEvaluateByLogisticsSuccess:(NSDictionary *)resultDic{
    
    if (_page == 1) {
        
        self.evaluateDatas = [JYEvaluateModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [JYEvaluateModel mj_objectArrayWithKeyValuesArray:resultDic];
        [self.evaluateDatas addObjectsFromArray:dataArr];
        if (dataArr.count < 10) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    }
    
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}

- (void)requGetEvaluateByLogisticsFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return self.evaluateDatas.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LookEvaluteTableViewCellOne *cell =[LookEvaluteTableViewCellOne cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        CGFloat attitude =[[self.dicData objectForKey:@"avgAttitudeScore"] doubleValue];
        NSString *attitudeStr = [NSString stringWithFormat:@"%0.1f分",attitude];
        
        CGFloat speed =[[self.dicData objectForKey:@"avgSpeedScore"] doubleValue];
        NSString *speedStr = [NSString stringWithFormat:@"%0.1f分",speed];
        
        CGFloat sum =[[self.dicData objectForKey:@"sum"] doubleValue];
        NSString *sumStr = [NSString stringWithFormat:@"%0.1f",sum];

        [cell setStartView:sumStr attitude:attitudeStr speed:speedStr];
        return cell;
    }
    
    if (indexPath.section == 1) {
        LookEvaluteTableViewCell *cell =[LookEvaluteTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.jyevaluateodel = self.evaluateDatas[indexPath.row];
        return cell;
        
    }
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
