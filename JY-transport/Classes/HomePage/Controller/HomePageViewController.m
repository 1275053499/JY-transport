//
//  HomePageViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "HomePageViewController.h"
//#import "DeliverGoodsViewController.h"
#import "LookForCarViewController.h"
//#import "lookForDriverMapController.h"
//#import "placeLocationViewController.h"

#import "DLSlideView.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"
#import "JYShipBaseViewController.h"

#import "TMCompanydetailsViewController.h"
@interface HomePageViewController ()<UITextFieldDelegate,DLSlideViewDelegate,DLSlideTabbarDelegate>
@property (strong, nonatomic)  UIButton *sendCarBtn;
@property (strong, nonatomic)  UIButton *sendShip;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self creatBtn];
    [self steBtnTitleFrame];

}

- (void)creatBtn{
   
    _sendShip =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendShip setTitle:@"我要发货" forState:(UIControlStateNormal)];
    [_sendShip setBackgroundImage:[UIImage imageNamed:@"icon_woyaofahuo"] forState:(UIControlStateNormal)];
    _sendShip.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [_sendShip addTarget:self action:@selector(delivery:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_sendShip];
    
    _sendCarBtn =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendCarBtn setTitle:@"我要找车" forState:(UIControlStateNormal)];
    [_sendCarBtn setBackgroundImage:[UIImage imageNamed:@"icon_woyaozhaoche"] forState:(UIControlStateNormal)];
     _sendCarBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [_sendCarBtn addTarget:self action:@selector(lookForCar:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_sendCarBtn];
    
    
    CGFloat btnWidth = 181 *HOR_SCALE;
    CGFloat Space = (ScreenHeight - 50  - StateBarHeight - NavigationBarHeight - btnWidth * 2)/3;
    
    _sendCarBtn.frame = CGRectMake((ScreenWidth - btnWidth)/2,Space +10 , btnWidth, btnWidth);
    
    _sendShip.frame = CGRectMake((ScreenWidth - btnWidth)/2,2* Space + btnWidth + 10, btnWidth, btnWidth);
    
    [_sendCarBtn setTitle:NSLocalizedString(@"我要找车", nil) forState:(UIControlStateNormal)];
    [_sendShip setTitle:NSLocalizedString(@"我要发货", nil) forState:(UIControlStateNormal)];
}

- (void)steBtnTitleFrame{
    
    _sendShip.titleEdgeInsets =UIEdgeInsetsMake(90 , 0, 0 , 0);
    _sendCarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -90 , 0);
}
- (void)DLSlideTabbar:(id)sender selectAt:(NSInteger)index{
    
    
}

/**
 *  设置导航栏的内容
 */
- (void)setupNavBar
{
    self.navigationItem.title = NSLocalizedString(@"首页", nil);

}
//我要找车
- (void)lookForCar:(UIButton *)sender {
   
    LookForCarViewController *lookForCarVC = [[LookForCarViewController alloc]init];
    [self.navigationController pushViewController:lookForCarVC animated:YES];
    
    
}



//我要发货

- (void)delivery:(UIButton *)sender {
    
    JYShipBaseViewController *delverGoodsVC = [[JYShipBaseViewController alloc]init];
    [self.navigationController pushViewController:delverGoodsVC animated:YES];
    
//    [MBProgressHUD showError:@"此功能即将开通"];

    //    placeLocationViewController *vc = [[placeLocationViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    TMCompanydetailsViewController *vc = [[TMCompanydetailsViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
