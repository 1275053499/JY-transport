

//
//  JYLookOutletsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookOutletsViewController.h"
#import "JYLookOutletsTableViewCell.h"
#import "JYMessageRequestData.h"
#import "JYOutletsModel.h"
@interface JYLookOutletsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate,JYMessageRequestDataDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *outletesaArr;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation JYLookOutletsViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 117;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)outletesaArr {
    if (_outletesaArr == nil) {
        _outletesaArr = [NSMutableArray array];
    }
    
    return _outletesaArr;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"查看网点";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.view.backgroundColor = BgColorOfUIView;
    [self queryAllOutlets];
    
//    // 创建UISearchController, 这里使用当前控制器来展示结果
//    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
//    // 设置结果更新代理
//    search.searchResultsUpdater = self;
//    // 因为在当前控制器展示结果, 所以不需要这个透明视图
//    search.dimsBackgroundDuringPresentation = NO;
//    // 是否自动隐藏导航
//    //        search.hidesNavigationBarDuringPresentation = NO;
//    self.searchController = search;
//    self.definesPresentationContext = YES;
    
    // 将searchBar赋值给tableView的tableHeaderView
//    self.tableView.tableHeaderView = search.searchBar;
    
//    search.searchBar.delegate = self;
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryAllOutlets{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager  requsetgetLogisticsbaranchListUrl:@"app/logisticsbaranch/getLogisticsbaranchList" ID:self.logisticsid];
    
}
- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic{
    
    self.outletesaArr = [JYOutletsModel mj_objectArrayWithKeyValuesArray:resultDic];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    

}
- (void)requestGetLogisticsbaranchListFailed:(NSError *)error{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.outletesaArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYLookOutletsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYLookOutletsTableViewCell  class]) owner:nil options:0][0];
    JYOutletsModel *model = self.outletesaArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.OutletsAddressLabel.numberOfLines = 0;
    cell.OutletsAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.supView.layer.cornerRadius = 2.0;
    cell.supView.layer.masksToBounds = YES;
    cell.OutletsNameLabel.text = model.name;
    cell.OutletsAddressLabel.text = model.address;
    [cell.callBtn setTitle:model.landline forState:(UIControlStateNormal)];
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        
        return cell;
    } else {
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 9;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        
        NSLog(@"选择了列表中的%@", [self.outletesaArr objectAtIndex:indexPath.row]);
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
//    for (NSString *str in self.outletesaArr) {
//
//        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
//
//            [self.results addObject:str];
//        }
//    }
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
