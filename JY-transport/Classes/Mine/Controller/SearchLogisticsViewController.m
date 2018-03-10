//
//  SearchLogisticsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/11/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SearchLogisticsViewController.h"
#import "MineRequestData.h"
#import "JYConfirmTableViewCellSecond.h"
#import "JYConfirmTableViewCellThird.h"
#import "JYLookEvaluateViewController.h"
#import "JYLookCompanyViewController.h"
#import "JYLookOutletsViewController.h"
#import "JYCompanyModel.h"
#import "MyLogisticsTableViewCell.h"
#import "CustomSearchBar.h"
#import "JYCompanyModel.h"
@interface SearchLogisticsViewController ()<MineRequestDataDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *logisticesArr;
@property (nonatomic,strong)CustomSearchBar *searchBar;


@end

@implementation SearchLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
  
    self.title = @"搜索物流";
    [self createTableView];
    
   
}

-(void)createTableView
{
    [self creatSearchBar];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,49, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    
}

- (void)creatSearchBar{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    CustomSearchBar *searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(12, (titleView.size.height - 34)/2, ScreenWidth-56-12, 34)];
    searchBar.placeholder = @"请输入公司名称／电话号码";
    _searchBar =searchBar;
    self.searchBar.delegate = self;
    [titleView addSubview:_searchBar];
    [self.view addSubview:titleView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(ScreenWidth -56,(titleView.size.height - 34)/2,56, 34);
    [btn setTitle:@"搜索" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:BGBlue forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn addTarget:self action:@selector(sureButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [titleView addSubview:btn];
    
    
}

- (void)sureButtonClick:(UIButton *)btn{
    
    [self searchBarSearchButtonClicked:self.searchBar];
    [self.view endEditing:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (self.searchBar.text.length >0) {
        [self.view endEditing:YES];
        [self searchResult:self.searchBar.text];
        
    }else{
        [MBProgressHUD showError:@"请输入正确的号码"];
    }
}
- (void)searchResult:(NSString *)condition{
    
    MineRequestData *manager = [MineRequestData shareInstance];
    
    manager.delegate = self;
    [manager requestSearchLogisticesWithPhone:@"app/user/getLogisticGroupByCondition" condition:condition];
}
- (void)requestSearchLogisticesWithPhoneSuccess:(id)resultDic{
    
    if (![resultDic objectForKey:@"message"]) {
        NSArray *arr =[NSArray arrayWithObject:resultDic];
        self.logisticesArr = [JYCompanyModel mj_objectArrayWithKeyValuesArray:arr];
        self.tableView.hidden = NO;
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
    }else{
        
        [MBProgressHUD showError:@"请输入正确的号码"];
        [_tableView removeFromSuperview];
    }
    
    
}

- (void)requestSearchLogisticesWithPhoneFailed:(NSError *)error{

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
