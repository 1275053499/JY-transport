//
//  SearchLookCarOrderVC.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SearchLookCarOrderVC.h"
#import "EmptyTableView.h"
#import "OrderTableViewCell.h"
#import "orderDetailViewController.h"
@interface SearchLookCarOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)EmptyTableView *tableView;
@end

@implementation SearchLookCarOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.title = @"查询结果";
    self.view.backgroundColor = BgColorOfUIView;
    [self creatTableView];
    if (_inquireArr.count <= 0) {
         [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.inquireArr.count frame:self.tableView.frame];
    }
    
  
    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//创建UItableView
-(void)creatTableView
{
    
    self.tableView = [[EmptyTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - NavigationBarHeight - StateBarHeight ) style:UITableViewStyleGrouped];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 188;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return self.inquireArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView];
        cell.model = self.inquireArr[indexPath.section];
        
        return cell;
   
    
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
    
        orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
        
        OrderModel *orderModel = self.inquireArr[indexPath.section];
        orederVC.OrderModel= orderModel;
        
        
        [self.navigationController pushViewController:orederVC animated:YES];
        
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
