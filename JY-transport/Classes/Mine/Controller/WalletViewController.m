//
//  WalletViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "WalletViewController.h"
#import "balanceDetailController.h"
#import "MyBalanceCell.h"
#import "MineRequestDataDelegate.h"
#import "MineRequestData.h"
#import "JYwalletTableViewSecondCell.h"
#import "MineTableViewCell.h"
#import "JYWalletRechargeViewController.h"

#import "PasswordViewController.h"
#import "TMLocationManager.h"
@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MineRequestDataDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)CGFloat balance;
@property(nonatomic,copy)NSString *balanceId;

@property (nonatomic,assign)BOOL isSetPassword;

@property (nonatomic,strong)TMLocationManager  *manager;


@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithIcon:@"icon_gengduo" highIcon:@"icon_gengduo" target:self action:@selector(addmore)];
    self.balance = 0;
    self.isSetPassword = NO;
    self.navigationItem.title = @"我的钱包";
    [self createTableView];
    [self senderHttpReque];
    [self creatBtnItem];
    
}
- (void)addmore{
    
    if (_isSetPassword == NO) {
        
        [self ChangeInfoImag:@"设置密码"];
    }else{
        [self ChangeInfoImag:@"修改密码"];
        
    }
}


- (void)creatBtnItem{
    
    UIButton *rightItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightItem.frame = CGRectMake(ScreenWidth - 44 -8 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [rightItem setImage:[UIImage imageNamed:@"icon_gengduo"] forState:(UIControlStateNormal)];
    [rightItem setImage:[UIImage imageNamed:@"icon_gengduo"] forState:(UIControlStateHighlighted)];
    
    [rightItem addTarget:self action:@selector(addmore) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightItem];
    
    UIButton *leftItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftItem.frame = CGRectMake(5 , StateBarHeight + NavigationBarHeight / 2 - 44/2, 44, 44);
    [leftItem setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [leftItem setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateHighlighted)];
    
    [leftItem addTarget:self action:@selector(returnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:Default_APP_Font size:20];
    titleLabel.text = @"我的钱包";
    titleLabel.frame = CGRectMake((ScreenWidth - 100)/2,StateBarHeight + NavigationBarHeight / 2 - 22/2 , 100, 22);
    
    [self.view addSubview:titleLabel];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
    UIViewController *topVC =  self.navigationController.topViewController;
    if ([topVC isKindOfClass:NSClassFromString(@"MineViewController")]) {
        
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    
  _manager =  [TMLocationManager sharelocationManager];
    [_manager startLoaction];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self senderHttpReque];
    
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
//调用相机或相册
- (void)ChangeInfoImag:(NSString *)setPasswordType{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *payDetailAction = [UIAlertAction actionWithTitle:@"交易记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self goTobalanceDetail];
        
    }];
    UIAlertAction *changeDense = [UIAlertAction actionWithTitle:@"修改支付密码" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [self changePassworld];

    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [payDetailAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [changeDense setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    
    [alert addAction:payDetailAction];
    [alert addAction:changeDense];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)changePassworld{
    
    
    PasswordViewController *vc = [[PasswordViewController alloc] init];
    
    if (_isSetPassword == NO) {
        
        vc.passwordType = PassWordTypeSetNew;
    }else{
        
        vc.passwordType = PassWordTypeChange;
        
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


//进入交易明细
-(void)goTobalanceDetail
{
    balanceDetailController *balanceVC = [[balanceDetailController alloc]init];
    balanceVC.balanceId = self.balanceId;
    [self.navigationController pushViewController:balanceVC animated:YES];
    
}
- (void)requestDataGetWalletForDriverSuccess:(NSDictionary *)resultDic{
    
    NSString *balanceStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"balance"]];
    self.balance = [balanceStr floatValue];
    self.balanceId = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"id"]];
    [self.tableView reloadData];
    
    NSString *wallpw = [resultDic objectForKey:@"wallpw"];
    if ([wallpw isEqual:[NSNull null]] || wallpw == nil || wallpw.length <= 0) {
        
        [self presentTipAlertSetCode];
        
        _isSetPassword = NO;
    }else{
        _isSetPassword = YES;
    }

    
}

- (void)requestDataGetWalletForDriverFailed:(NSError *)error{
    
    [MBProgressHUD showError:@"网络异常"];
    
}

- (void)presentTipAlertSetCode{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"为了您的账户安全，请设置钱包密码" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self changePassworld];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //点击按钮的响应事件
    
    [alert addAction:cancelAction];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)senderHttpReque
{
    self.dataArr = [NSMutableArray array];
    MineRequestData *manager  = [MineRequestData shareInstance];
    manager.delegate = self;
    [manager requestDataGetWalletForDriver:nil phone:nil idea:nil];


    
}


-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *topView  = [[UIView alloc] initWithFrame:CGRectMake(0, -180, ScreenWidth, 180)];
    topView.backgroundColor = RGB(255, 133, 51);
    topView.tag = 101;
    [self.tableView addSubview:topView];
    topView.clipsToBounds = YES;//删除多余图片（第一行被遮盖)

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYwalletTableViewSecondCell *cell = [JYwalletTableViewSecondCell cellWithTableView:tableView];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.lineView.hidden = YES;
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.accessoryImg.image = [UIImage imageNamed:@"icon_jiantou2"];
    if (indexPath.section == 0) {
        MyBalanceCell *cel = [MyBalanceCell cellWithTableView:tableView];
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
        cel.backgroundColor = RGB(255, 133, 51);
        cel.contentView.backgroundColor = RGB(255, 133, 51);
        cel.moneyNumber.text = [NSString stringWithFormat:@"¥%.2f",self.balance];
        
        return cel;
    }else {
       
        cell.nameLabel.text = @"充值";
        cell.lineView.hidden = NO;

        return cell;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 230;
    }else{
        return 50;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (indexPath.section == 1) {
//            JYWalletRechargeViewController *vc = [[JYWalletRechargeViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else if (indexPath.section == 2){
//            WithdrawViewController *controller = [[WithdrawViewController alloc]init];
//            [self.navigationController pushViewController:controller animated:YES];
//
//        }
    if (indexPath.section == 1) {
        JYWalletRechargeViewController *vc = [[JYWalletRechargeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

@end
