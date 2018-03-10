//
//  MineViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MineViewController.h"
#import "WalletViewController.h"
#import "travellingDetailViewController.h"
#import "SetViewController.h"
#import "CarFleetViewController.h"
#import "ChangeInformationViewController.h"
#import "ScanViewController.h"
#import "EditPersonalInfoVC.h"
#import "NearbyVehiclesVC.h"
#import "UserInfoModel.h"
#import "MineIconTableViewCell.h"
#import "JYMyiconTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyLogisticsViewController.h"
#import "MyiconImageView.h"
#import "MineTableViewCell.h"
#import "CouponViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UserInfoModel *userModel;
@property (nonatomic,strong)MyiconImageView *imageView;
@end



@implementation MineViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    
    [self createTableView];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"intercalate" highIcon:@"intercalate" target:self action:@selector(setting)];
    [self creatBtnItem];
    
    
    
    
}

- (void)setting
{
    SetViewController *setVC = [[SetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)creatBtnItem{
    
    UIButton *rightItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightItem.frame = CGRectMake(ScreenWidth - 44 -8 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [rightItem setImage:[UIImage imageNamed:@"intercalate"] forState:(UIControlStateNormal)];
    [rightItem setImage:[UIImage imageNamed:@"intercalate"] forState:(UIControlStateHighlighted)];
    
    [rightItem addTarget:self action:@selector(setting) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:Default_APP_Font size:20];
    titleLabel.text = @"我的";
    titleLabel.frame = CGRectMake((ScreenWidth - 100)/2,StateBarHeight + NavigationBarHeight / 2 - 22/2 , 100, 22);
    
    [self.view addSubview:titleLabel];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //如果不想让其他页面的导航栏变为透明 需要重置

    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    

    if (self.tabBarController.selectedIndex == 3) {//此处避免minevc 因为下面动画抖动，不用动画会有bug
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];

    }else{
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];

    }
    
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    _imageView.userModel = _userModel;
    [_tableView reloadData];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight -49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BgColorOfUIView;
  
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);

    _imageView  = [[MyiconImageView alloc] initWithFrame:CGRectMake(0, -180, ScreenWidth, 180)];
    _imageView.tag = 101;
    _imageView.userModel = _userModel;
    [self.tableView addSubview:_imageView];
    _imageView.clipsToBounds = YES;//删除多余图片（第一行被遮盖)
    [_imageView.chooseIconBtn addTarget:self action:@selector(editorPersonInfo:) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)editorPersonInfo:(UIButton *)btn{
    
    EditPersonalInfoVC * editPersonaVC = [[EditPersonalInfoVC alloc] init];
    [self.navigationController pushViewController:editPersonaVC animated:YES];
        
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -180) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        
        return 2;
        
    }else{
        
        return 2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineTableViewCell *cell = [MineTableViewCell cellWithTableView:tableView];
   
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.accessoryImg.image = [UIImage imageNamed:@"icon_jiantou2"];

    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.imgView.image = [UIImage imageNamed:@"icon_qianbao"];
            cell.nameLabel.text = @"我的钱包";

        }else{
            
            cell.imgView.image =[UIImage imageNamed:@"icon_youhuiquan"];
            cell.nameLabel.text=@"优惠券";
 
        }
        
            return cell;
    }else if(indexPath.section == 1){
        
        
        if (indexPath.row == 0){
            
            cell.imgView.image =[UIImage imageNamed:@"icon_wodechedui"];
            cell.nameLabel.text=@"我的车队";
            
        }else if (indexPath.row == 1){
            
            cell.imgView.image =[UIImage imageNamed:@"icon_wodewuliu"];
            cell.nameLabel.text=@"我的物流";
        }
    
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            cell.imgView.image =[UIImage imageNamed:@"icon_lufeixiangqing"];
            cell.nameLabel.text=@"路费详情";
            
            
        }else if (indexPath.row == 1){
            
            cell.imgView.image =[UIImage imageNamed:@"icon_lianxikefu"];
            cell.nameLabel.text=@"联系客服";
            cell.lineView.hidden = YES;
        }
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 0.001;
    }else{
        
        return 9;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            
            WalletViewController *walletVC = [[WalletViewController alloc]init];
            [self.navigationController pushViewController:walletVC animated:YES];
            
        }else{
            
            CouponViewController *couponVC = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
            
        }
        
    }else if (indexPath.section == 1){
        
         if (indexPath.row == 0){
            
            CarFleetViewController *carFleetVC = [[CarFleetViewController alloc]init];
            carFleetVC.pushFromVC = @"MineViewController";
            [self.navigationController pushViewController:carFleetVC animated:YES];
            
        }else {
        
            MyLogisticsViewController *logisticsVC = [[MyLogisticsViewController alloc]init];
            [self.navigationController pushViewController:logisticsVC animated:YES];
           
        }
    
    }else{
        
        if (indexPath.row==0) {
            
            travellingDetailViewController *trabellingDetailVC = [[travellingDetailViewController alloc]init];
            [self.navigationController pushViewController:trabellingDetailVC animated:YES];
            
        }else {
            
            [self presentAlertActionSheet];

        }
        
    }
    
}
- (void)presentAlertActionSheet{

//        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"075521016380"];
//        UIWebView *callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"075521016380"];
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
  
}

- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}




@end

