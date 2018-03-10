//
//  LookEvaluateViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LookEvaluateViewController.h"
#import "LookEvaluteTableViewCell.h"
#import "LookEvaluteTableViewCellOne.h"
#import "MessageRequestDelegate.h"
#import "MessageRequsetData.h"

#import "EvaluateModel.h"
@interface LookEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,MessageRequestDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *evaluateDatas;
@property (nonatomic,strong)NSDictionary *dicData;
@end

@implementation LookEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _evaluateDatas = [NSMutableArray array];
    self.title = @"评价";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self creatTableView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [self addRefreshView];
    
    
    
    MessageRequsetData *messageData = [[MessageRequsetData alloc] init];
    messageData.delegate = self;
    if (self.driverPhone == nil || self.driverPhone.length == 0 || [self.driverPhone isEqual:[NSNull null]]) {
        
    }else{
        
        [messageData requestDataDriverEvaluate:@"" DriverPhone:self.driverPhone];
    }

    
}

- (void)addRefreshView{
    
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requsetData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
//    默认block方法：设置上拉加载更多 
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//       
//        
//   }];
    
}
- (void)requsetData{
    
    MessageRequsetData *messageData = [[MessageRequsetData alloc] init];
    messageData.delegate = self;
    if (self.driverPhone == nil || self.driverPhone.length == 0 || [self.driverPhone isEqual:[NSNull null]]) {
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    }else{
        
         [messageData requestDataForMessageEvaluate:nil evObject:self.driverPhone];
    }
    
}


//请求成功
- (void)requestDataForEvaluteSuccess:(id)resultDic{

    self.evaluateDatas = [EvaluateModel mj_objectArrayWithKeyValuesArray:resultDic];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
//请求失败
- (void)requestDataForEvaluteFailed:(NSError *)error{
    
      [self.tableView.mj_header endRefreshing];
    
}


- (void)requestDataForDriverEvaluateSuccess:(NSDictionary *)resultDic{
    
    self.dicData = resultDic;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)requestDataForDriverEvaluateFailed:(NSError *)error{
    
    
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
        
        CGFloat attitude =[[self.dicData objectForKey:@"evGrade"] doubleValue];
        NSString *attitudeStr = [NSString stringWithFormat:@"%0.1f分",attitude];
        
        CGFloat speed =[[self.dicData objectForKey:@"evPotin"] doubleValue];
        NSString *speedStr = [NSString stringWithFormat:@"%0.1f分",speed];
        
        CGFloat sum =[[self.dicData objectForKey:@"sum"] doubleValue];
        NSString *sumStr = [NSString stringWithFormat:@"%0.1f",sum];
        
        [cell setStartView:sumStr attitude:attitudeStr speed:speedStr];
        return cell;
    }
    
    if (indexPath.section == 1) {
        LookEvaluteTableViewCell *cell =[LookEvaluteTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.evaluateodel = self.evaluateDatas[indexPath.row];
        return cell;

    }
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
