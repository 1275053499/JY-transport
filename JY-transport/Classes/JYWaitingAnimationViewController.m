//
//  JYWaitingAnimationViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWaitingAnimationViewController.h"

#import "JYConfirmPriceViewController.h"
#import "WaitingHeardView.h"
#import "JYAddressDetailViewController.h"
#import "JYHomeRequestDate.h"
#import "cancelAlertView.h"
#import "JYOrderDetailViewController.h"
@interface JYWaitingAnimationViewController ()<JYHomeRequestDateDelegate,cancelAlertViewDelegate>

@property (nonatomic,strong)UIImageView *imgView;//动画view

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIView *superView;//底视图
@property (nonatomic,strong)WaitingHeardView *waitView;//头部步骤视图
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)NSString  *status;
@property (nonatomic,strong)JYConfirmPriceViewController *confirmpriceVC;
@property (nonatomic,strong)JYAddressDetailViewController *addressDetailVC;
@property (nonatomic,strong)cancelAlertView *cancelAlert;
@property (nonatomic,strong)NSArray *arr;
@end

@implementation JYWaitingAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self creatSuperView];
    [self initOrderDetailType];
    self.navigationItem.title = @"等待服务";
    self.arr = @[@"时间临时有变",@"价钱没谈好",@"信息填写错误，要重新下订单",@"其他原因"];
self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    //物流公司估价 通知 停止动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCompanyPrice:) name:@"getCompanyPrice" object:nil];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"查看订单" target:self action:@selector(finshBtnBtnClick)];

    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification
 object:nil];
    
}
//前台
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{

    if ([_orderDetailType isEqualToString:@"animation"]) {
        
        _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight ,ScreenWidth,50);
        _superView.frame = CGRectMake(0, 118, ScreenWidth,ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -118);
        
    }else if ([_orderDetailType isEqualToString:@"SurePrice"]){
         _confirmpriceVC.view.frame = CGRectMake(0, 9, ScreenWidth, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -118);
        _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,135,50);
        _sureBtn.frame = CGRectMake(135, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,(ScreenWidth - 135), 50);
    }else if ([_orderDetailType isEqualToString:@"SureOrder"]){
        
        _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,ScreenWidth, 50);
    }

}

- (void)finshBtnBtnClick{
    
    JYOrderDetailViewController *vc = [[JYOrderDetailViewController alloc] init];
    vc.orderID = self.orderID;
    vc.orderStatus = @"20";//6 的状态会隐藏其他cell 价格 公司 信息等
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)returnAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)startAnimation
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0.f];

    rotationAnimation.duration = 2.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;

    rotationAnimation.repeatCount = HUGE_VALF;
//  rotationAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation
{
    [self.imgView.layer removeAllAnimations];
}

- (void)initOrderDetailType{
    
    
    if ([_orderDetailType isEqualToString:@"animation"]) {
        [self addAnimationView];
    }else if ([_orderDetailType isEqualToString:@"SurePrice"]){
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

        [self conFirmOrderPrice];
    }else if ([_orderDetailType isEqualToString:@"SureOrder"]){
        
        [self conFirmOrderAddress];
    }
}
- (void)addAnimationView{
    
    _orderDetailType = @"animation";
    [self stopAnimation];
    [_confirmpriceVC removeFromParentViewController];
    for (UIView *view in _superView.subviews) {
        [view removeFromSuperview];
    }
    _waitView.frame = CGRectMake(0, 0, ScreenWidth, 118);
    _waitView.lineLeftView.backgroundColor = RGB(204, 204, 204);
    _waitView.lineRightView.backgroundColor = RGB(204, 204, 204);

    _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight ,ScreenWidth,50);
    _cancelBtn.backgroundColor = BGBlue;
    
    _waitView.btnTwo.selected = NO;
    _sureBtn.hidden = YES;
    _superView.backgroundColor = [UIColor whiteColor];

    
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.frame = CGRectMake((ScreenWidth -110)/2 ,70,110 ,104 );
    imgview.image = [UIImage imageNamed:@"animation"];
    [_superView addSubview:imgview];
    _imgView = imgview;
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = BGBlue;
    lab.frame = CGRectMake((ScreenWidth - 200)/2, 200, 300, 25);
    lab.text = @"稍等一会儿，物流公司正在出价";
    lab.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
    [_superView addSubview:lab];
    [self startAnimation];

}

- (void)creatSuperView{
    
    _waitView = [[WaitingHeardView alloc] init];
    _waitView.frame = CGRectMake(0, 0, ScreenWidth, 118);
    _waitView.lineLeftView.backgroundColor = RGB(204, 204, 204);
    _waitView.lineRightView.backgroundColor = RGB(204, 204, 204);

    [self.view addSubview:_waitView];
    
    _superView = [[UIView alloc] initWithFrame:CGRectMake(0, 118, ScreenWidth,ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -118)];
    _superView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_superView];
    
    
    
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight ,ScreenWidth,50);
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:BGBlue];

    _cancelBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];

    
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(135, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,(ScreenWidth - 135), 50);
    [_sureBtn setTitle:@"确定服务" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [_sureBtn setBackgroundColor:BGBlue];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureBtn];
    _sureBtn.hidden = YES;
    

}
- (void)conFirmOrderPrice{
    
    _orderDetailType = @"SurePrice";

    for (UIView *view in _superView.subviews) {
        [view removeFromSuperview];
    }
    _sureBtn.hidden = NO;
    _waitView.lineLeftView.backgroundColor = BGBlue;
    _waitView.btnTwo.selected = YES;
    _cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,135,50);
    [_cancelBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    _sureBtn.frame = CGRectMake(135, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,(ScreenWidth - 135), 50);
    
    
     _confirmpriceVC = [[JYConfirmPriceViewController alloc] init];
    _confirmpriceVC.view.frame = CGRectMake(0, 9, ScreenWidth, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -118);
    [self addChildViewController:_confirmpriceVC];
    [_superView addSubview:_confirmpriceVC.view];
    _superView.backgroundColor = BgColorOfUIView;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder_EvulteFinish" object:nil];

    
}

//
- (void)conFirmOrderAddress{
    
    _orderDetailType = @"SureOrder";

    [_confirmpriceVC removeFromParentViewController];
    for (UIView *view in _superView.subviews) {
        [view removeFromSuperview];
    }

    
    _cancelBtn.hidden = YES;
    _sureBtn.hidden = NO;

    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight,ScreenWidth, 50);

    _waitView.lineLeftView.backgroundColor = BGBlue;
    _waitView.lineRightView.backgroundColor = BGBlue;
    _waitView.btnTwo.selected = YES;
    _waitView.btnThree.selected = YES;

     _addressDetailVC = [[JYAddressDetailViewController alloc] init];
    _addressDetailVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -118);
    [self addChildViewController:_addressDetailVC];
    [_superView addSubview:_addressDetailVC.view];
    
    _superView.backgroundColor = BgColorOfUIView;
    
}
- (void)getCompanyPrice:(NSNotification *)noti{
    
    [self conFirmOrderPrice];
    
}

//确认价格
- (void)requestSurePrice{
    
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    [manager requsetConfirmationPrice:@"app/logisticsorder/confirmationProvider" orderID:self.orderID];
}
     
     
-(void)requsetConfirmationPriceSuccess:(NSDictionary *)resultDic{
  
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        [self conFirmOrderAddress];

    }
}

- (void)requsetConfirmationPriceFailed:(NSError *)error{
    
    
}
//取消物流公司
- (void)cancelCompany{
    
    if ([_orderDetailType isEqualToString:@"SurePrice"]) {
        JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
        manager.delegate = self;
        [manager requsetCancellationProvider:@"app/logisticsorder/cancellationProvider" orderID:self.orderID];
        
    }
}

- (void)cancelOrderByUser{
    
    
    _cancelAlert = [cancelAlertView GlodeBottomView];
    _cancelAlert.titleArray = self.arr;
    _cancelAlert.delegate = self;
    [_cancelAlert show];

}
// 点击取消按钮
- (void)cancelBtnClick:(UIButton *)btn{
    if ([_orderDetailType isEqualToString:@"animation"]) {
        [self cancelOrderByUser];
    }
    
    if ([_orderDetailType isEqualToString:@"SurePrice"]) {
        
        [self cancelCompany];

    }
}
- (void)requsetCancellationProviderSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {

        [self addAnimationView];
    }
    
}
- (void)requsetCancellationProviderFailed:(NSError *)error{
    
    
}
//点击确定按钮
- (void)sureBtnClick:(UIButton *)btn{

   if ([_orderDetailType isEqualToString:@"SurePrice"]){
       
       [self requestSurePrice];

    }else if ([_orderDetailType isEqualToString:@"SureOrder"]){
        
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"SureOrder" object:nil];
    }
    
}
//取消订单
- (void)cancelReasonButtonClick:(NSInteger)index content:(NSString *)str{
    
    
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    [manager requsetCancelOrder:@"app/logisticsorder/cancelOrderByUser" cancelType:str cancelContent:@"0" orderId:self.orderID];
}
- (void)requsetCancelOrderSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        [_cancelAlert dissMIssView];
        [self.navigationController popViewControllerAnimated:YES];

    }
}
- (void)requsetCancelOrderFailed:(NSError *)error{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCompanyPrice" object:nil];
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
