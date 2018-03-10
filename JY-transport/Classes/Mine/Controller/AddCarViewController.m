
//
//  AddCarViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "AddCarViewController.h"
#import "carTeamTableViewCell.h"
#import "DriverInfoMode.h"
#import "CustomSearchBar.h"
@interface AddCarViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *driverInfoArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CustomSearchBar *searchBar;
@property (nonatomic,strong)carTeamTableViewCell *cell;
@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"添加车辆";
    _driverInfoArr = [NSMutableArray array];
    [self creatSearchBar];
    [self creatTableView];
}
- (void)creatSearchBar{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
   CustomSearchBar *searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(12, (titleView.size.height - 34)/2, ScreenWidth-56-12, 34)];
    _searchBar =searchBar;
    searchBar.placeholder = @"请输入手机号码／车牌号";
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
- (void)creatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 + 9, ScreenWidth , 120) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource =self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight =110;
    _tableView  = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
   
}
- (void)sureButtonClick:(UIButton *)btn{
    
    [self searchBarSearchButtonClicked:self.searchBar];
    [self.view endEditing:YES];

}
- (UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _driverInfoArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     _cell = [carTeamTableViewCell cellWithTableView:tableView];
//    _cell.backgroundColor = RGBA(204, 204, 204, 1);
    [_cell.collectionBtn addTarget:self action:@selector(collentionClick:) forControlEvents:UIControlEventTouchUpInside];

    _cell.driverinfoMode = self.driverInfoArr[indexPath.row];
    return _cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_cell.driverinfoMode.isCollection isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不可重复收藏"];
    }else{
        
        [self uploadCollection];
        
    }
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
       if (self.searchBar.text.length >0) {
           [self.view endEditing:YES];

           [self queryData];
    }else{
      [MBProgressHUD showError:@"请输入正确的号码"];
    }
}
- (void)collentionClick:(UIButton *)btn{
    
    if ([_cell.driverinfoMode.isCollection isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不可重复收藏"];
    }else{
        
        [self uploadCollection];
        
    }
}
- (void)uploadCollection{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/truckCollection"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"userPhone":userPhone,@"truckPhone":_cell.driverinfoMode.phone} success:^(id responseObj) {
       
    [_cell.collectionBtn setBackgroundImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:@"收藏成功"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];

}
//请求数据
-(void)queryData
{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/getSimpleByCondition"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"condition":self.searchBar.text,@"userPhone":userPhone} success:^(id responseObj) {
        NSArray *arr =[NSArray arrayWithObject:responseObj];
        self.driverInfoArr = [DriverInfoMode mj_objectArrayWithKeyValuesArray:arr];
        if (![responseObj objectForKey:@"message"]) {
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];

        }else{
        
            [MBProgressHUD showError:@"请输入正确的号码"];
            [_cell removeFromSuperview];
            [_tableView removeFromSuperview];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
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
