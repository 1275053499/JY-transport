//
//  payViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "payViewController.h"
#import "payOrderNumberCell.h"
#import "payTypeTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "evaluateViewController.h"

#import "HomePageViewController.h"
#import "JYPayCouponViewController.h"
#import <WXApi.h>
#import "MineCouponModel.h"

#import "PopPasswordView.h"
#import "NSString+Hash.h"
@interface payViewController ()<UITableViewDelegate,UITableViewDataSource,TMTextFieldViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *isSeleButtonStr;
@property (nonatomic,strong)MineCouponModel *couponModel;
@property (nonatomic,strong)UILabel *payNumber;
@property (nonatomic,assign)int chooseBtn;
@property (nonatomic,strong)PopPasswordView *passwordView;
@property (nonatomic,strong)NSString *totalMoney;
@property (nonatomic,strong)NSString *couponVaule;//优惠券
@property (nonatomic,assign)BOOL isPayMoneyZero;//
@property (nonatomic,strong)UIView *footView;

@end

@implementation payViewController


#pragma mark - action handle
- (void)returnAction
{
    if ([_pushFromWhichVC isEqualToString:@"UIAlertController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"支付订单";
    [self createTableView];
    [self createFootView];
    _isSeleButtonStr = @"";
    _couponVaule = @"0";
    _isPayMoneyZero = NO;
   
    _totalMoney = [NSString stringWithFormat:@"%.2f",self.model.bid];
    
    _chooseBtn = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccess:) name:@"alPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccess:) name:@"WXPaySuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
   

}

-(void)PaySuccess:(NSNotification*)notification{
    
    [self presentAlertView];
}

- (void)presentAlertView{
 
    NSString *title = @"支付成功";
//    NSString *message = [NSString stringWithFormat:@"已付款  ¥ %.2f",self.model.bid];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        evaluateViewController *evaluateVC = [[evaluateViewController alloc]init];
        evaluateVC.model = self.model;
        [self.navigationController pushViewController:evaluateVC animated:YES];
        
    }];
    
    [alert addAction:actionSure];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight- StateBarHeight - NavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];
}
//前台
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 50);
    self.footView.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight, ScreenWidth, 50);
}
-(void)createFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50- NavigationBarHeight - StateBarHeight, ScreenWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    _footView = footView;
    [self.view addSubview:footView];
    
    
    //确定付款
    
    FMButton *payButton = [FMButton createFMButton];
    [payButton setBackgroundColor:[UIColor colorWithHexString:@"#118AE7"]];
    [payButton setTitle:@"确认付款" forState:UIControlStateNormal];
    [footView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(footView.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(footView.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(50);
         
    }];
    
    
   
    //待支付
    UILabel *payNumberLabel = [[UILabel alloc]init];
    payNumberLabel.text = @"共支付:";
    payNumberLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    payNumberLabel.textAlignment = NSTextAlignmentRight;
    payNumberLabel.font = [UIFont fontWithName:Default_APP_Font size:16];
    [footView addSubview:payNumberLabel];
    [payNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.centerY.mas_equalTo(footView.mas_centerY).mas_offset(0);
        
    }];
    //待支多少
    UILabel *payNumber = [[UILabel alloc]init];

    payNumber.text = [@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f",self.model.bid]];
    payNumber.textColor = [UIColor colorWithHexString:@"#E71111"];
    payNumber.textAlignment = NSTextAlignmentRight;
    payNumber.font = [UIFont fontWithName:Default_APP_Font size:18];
    [footView addSubview:payNumber];
    _payNumber = payNumber;
    [payNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payNumberLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(footView.mas_centerY).mas_offset(0);
        
    }];
    
    //确认付款
    payButton.block = ^(FMButton *button){
    
        [self surePayOrderMoney];
    
    };


}
 // 点击确认付款按钮
-(void)surePayOrderMoney
{
    
    if ([_isSeleButtonStr isEqualToString:@""]) {
        
        [MBProgressHUD showSuccess:@"请选择一种支付方式"];
        
    }else if ([_isSeleButtonStr isEqualToString:@"余额支付"]){
        
//        [self balancePayMoney];
        [self payMoneyForBalance];
        
    }else if ([_isSeleButtonStr isEqualToString:@"支付宝支付"]){
        if (_isPayMoneyZero == YES) {
            
           [self changeOrderType];
        }else{
            [self payMoneyAlipayHttp];

        }
        
    
    }else if ([_isSeleButtonStr isEqualToString:@"微信支付"]){
        if (_isPayMoneyZero == YES) {
            
           [self changeOrderType];
        }else{
          [self senderWXApi];
            
        }
        
       
        
    }else if ([_isSeleButtonStr isEqualToString:@"现金支付"]){
        
        [self presentTipAlertOrderType];
        
    }else{
    
    
    }
}


- (void)payMoneyForBalance{
    
    self.passwordView = [[PopPasswordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.passwordView.tmPasswordView.delegate = self;
    self.passwordView.money = _totalMoney;
    [self.passwordView.tmPasswordView.pwdTextField becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self.passwordView];
    
}
/**
 *  输入密码回调
 */
#pragma mark ======== delegate =========
- (void)passWordCompleteInput:(TMTextFieldView *)passWord{
    
    NSString *pwd =  [self encrybtion:passWord.pwdPassword];
    [self checkThePassword:pwd];
    
}

- (NSString *)encrybtion:(NSString *)code{
    
    NSString * pwdStr = [code stringByAppendingString:salt];
    NSString *pwdStrCode = pwdStr.md5String;
    return pwdStrCode;
}
//校验密码
- (void)checkThePassword:(NSString *)str{
    //idea（0用户1司机2物流）
    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:@"app/wallet/checkThePassword"];
    NSString *phone = userPhone;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"pwd":str,@"idea":@"0"} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            [self.passwordView removeFromSuperview];
            [self balancePayMoney];
          
            
        }else{
            [MBProgressHUD showError:@"密码错误"];
            [self.passwordView.tmPasswordView deleteAllPassWord];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        [MBProgressHUD showError:@"失败"];
        
    }];
}



- (void)presentTipAlertOrderType{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定使用现金付款吗？" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [self changeOrderType];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
      
        
    }];
    
      [alert addAction:cancelAction];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

  //发送请求 现金支付  改变订单状态
-(void)changeOrderType
{

    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/cashEndCharteredReq"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo":self.model.orderNo} success:^(id responseObj) {
        
        
        if ([[responseObj objectForKey:@"message"] isEqualToString:@"0"])
        {
             evaluateViewController *evaluateVC = [[evaluateViewController alloc]init];
            evaluateVC.model = self.model;
            [self.navigationController pushViewController:evaluateVC animated:YES];
            
        }
    
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];

}
//微信支付
- (void)senderWXApi{
    
    if([WXApi isWXAppInstalled]) {
        // 监听一个通知
        NSString *urlStr = [base_url stringByAppendingString:@"app/wechat/wxPrePay"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
        
        
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo":self.model.orderNo} success:^(id responseObj) {
            
            
            NSDictionary *payDic;
            NSLog(@"=======%@",responseObj);
            if ([[responseObj objectForKey:@"code"] isEqualToString:@"200"]) {
                payDic = [responseObj objectForKey:@"msg"];
            }
            
            PayReq *req  = [[PayReq alloc] init];
            req.partnerId = [payDic objectForKey:@"partnerid"];
            req.prepayId = [payDic objectForKey:@"prepayid"];
            req.package = [payDic objectForKey:@"package"];
            req.nonceStr = [payDic objectForKey:@"noncestr"];
            req.timeStamp = [[payDic objectForKey:@"timestamp"]intValue];
            req.sign = [payDic objectForKey:@"sign"];
            
            //调起微信支付
            if ([WXApi sendReq:req]) {
                NSLog(@"吊起成功");
            }
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];
        }];

        
        
        
    }
    
}

- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        NSLog(@"支付成功");
    } else {
        NSLog(@"支付失败");
    }
    
}
//余额支付
- (void)balancePayMoney{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/wallet/balancePayment"];
    NSString *phone = userPhone;
    NSString *coup = @"";
    if ([_couponModel isEqual:[NSNull null]] || _couponModel == nil || _couponModel.ID == nil ) {
        
        coup = @"";
    }else{
        coup = _couponModel.ID;
    }
    
    NSDictionary *dic = @{@"orderNo":self.model.orderNo,@"phone":phone,@"cpId":coup};
    
    [[NetWorkHelper shareInstance] Post:urlStr parameter:dic success:^(id responseObj) {
       
        NSString *code  = [responseObj objectForKey:@"code"];
        NSLog(@"%@",[responseObj objectForKey:@"code"]);
        if ([code isEqualToString:@"200"]) {
            
            [MBProgressHUD showSuccess:@"支付成功"];
            
            
            evaluateViewController *evaluateVC = [[evaluateViewController alloc]init];
            evaluateVC.model = self.model;
            [self.navigationController pushViewController:evaluateVC animated:YES];
            
        }else if([code isEqualToString:@"510"]){
            
            [MBProgressHUD showError:@"余额不足"];
            
        }
        
        
    } failure:^(NSError *error) {
       
        [MBProgressHUD showError:@"支付失败"];

    }];
}
//支付宝
-(void)payMoneyAlipayHttp
{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/ali/getAliOrder"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo":self.model.orderNo,@"idea":@"1"} success:^(id responseObj) {
        
        NSLog(@"=======%@",responseObj);

        //调起支付宝支付
        NSString *alipayScheme = @"JY-transport";
        [[AlipaySDK defaultService] payOrder:responseObj fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
            
            
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;

    
    }else{
        return 5;

    }
    
   }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *ID = @"SetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
  
    if (indexPath.section == 0) {
        payOrderNumberCell *cell = [payOrderNumberCell cellWithOrderTableView:tableView];
        cell.mainTitleLabe.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        cell.subTitileLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        
        if (indexPath.row ==0) {
            cell.mainTitleLabe.textColor = BGBlue;
            cell.subTitileLabel.textColor = BGBlue;
            cell.mainTitleLabe.text=@"订单号：";
            cell.subTitileLabel.text = self.model.orderNo;
        }else{
            cell.mainTitleLabe.text=@"待支付：";
            cell.subTitileLabel.text = [@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f",self.model.bid]];
            cell.mainTitleLabe.textColor = RGB(228, 122, 109);
            cell.subTitileLabel.textColor = RGB(228, 122, 109);
            
            
        }
         return cell;
        
    }else if (indexPath.section == 1){
        
        payTypeTableViewCell *cell = [payTypeTableViewCell cellWithOrderTableView:tableView];
        cell.payIcon.image =[UIImage imageNamed:@"icon_youhuiquan"];
        cell.detLabel.hidden = NO;
        cell.rightImg.hidden = NO;
        cell.payTypeLabel.text=@"优惠卷";
        cell.payTypeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        cell.payTypeLabel.textColor = RGB(51, 51, 51);
        cell.seletedButton.hidden = YES;
       
        NSString *coup = @"";
        if ([_couponModel isEqual:[NSNull null]] || _couponModel == nil) {
          
             coup = @"0";
        }else{
            coup = _couponModel.value;
        }
        cell.detLabel.text = [NSString stringWithFormat:@"-¥ %@",coup];
       

         return cell;
    
    }else{
       
    
        if (indexPath.row == 0 ) {
            payOrderNumberCell *cell = [payOrderNumberCell cellWithOrderTableView:tableView];
            cell.mainTitleLabe.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.subTitileLabel.hidden = YES;
            cell.mainTitleLabe.textColor = BGBlue;
            cell.mainTitleLabe.text=@"选择支付方式";
            
            return cell;
            
        }else if (indexPath.row == 1){
             payTypeTableViewCell *cell = [payTypeTableViewCell cellWithOrderTableView:tableView];
            cell.payIcon.image =[UIImage imageNamed:@"icon_payment"];
            cell.payTypeLabel.text=@"余额支付";
            cell.payTypeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.payTypeLabel.textColor = RGB(51, 51, 51);

             cell.seletedButton.tag = 10000 +indexPath.row;
            [cell.seletedButton setImage:[UIImage imageNamed:@"no_making_tick"] forState:UIControlStateNormal];
            [cell.seletedButton setImage:[UIImage imageNamed:@"making_tick"] forState:UIControlStateSelected];
            if ([_isSeleButtonStr isEqualToString:@"余额支付"]){
                
                cell.seletedButton.selected = YES;
                
            }
            
               return cell;
        }else if (indexPath.row == 2){
            payTypeTableViewCell *cell = [payTypeTableViewCell cellWithOrderTableView:tableView];
            cell.payIcon.image =[UIImage imageNamed:@"icon_ipay"];
            cell.payTypeLabel.text=@"支付宝支付";
            cell.payTypeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.payTypeLabel.textColor = RGB(51, 51, 51);
            
            cell.seletedButton.tag = 10000 +indexPath.row;
            [cell.seletedButton setImage:[UIImage imageNamed:@"no_making_tick"] forState:UIControlStateNormal];
            [cell.seletedButton setImage:[UIImage imageNamed:@"making_tick"] forState:UIControlStateSelected];
            if ([_isSeleButtonStr isEqualToString:@"支付宝支付"]){
                
                cell.seletedButton.selected = YES;
                
            }
            
            return cell;
        }else if (indexPath.row == 3){
             payTypeTableViewCell *cell = [payTypeTableViewCell cellWithOrderTableView:tableView];
            cell.payIcon.image =[UIImage imageNamed:@"icon_weixinzhifu"];
             cell.seletedButton.tag = 10000 +indexPath.row;
            [cell.seletedButton setImage:[UIImage imageNamed:@"no_making_tick"] forState:UIControlStateNormal];
            [cell.seletedButton setImage:[UIImage imageNamed:@"making_tick"] forState:UIControlStateSelected];
            cell.payTypeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.payTypeLabel.textColor = RGB(51, 51, 51);
            cell.payTypeLabel.text=@"微信支付";
            if ([_isSeleButtonStr isEqualToString:@"微信支付"]){
                
                cell.seletedButton.selected  = YES;
                
            }
               return cell;
        }else{
             payTypeTableViewCell *cell = [payTypeTableViewCell cellWithOrderTableView:tableView];
            [cell.seletedButton setImage:[UIImage imageNamed:@"no_making_tick"] forState:UIControlStateNormal];
            [cell.seletedButton setImage:[UIImage imageNamed:@"making_tick"] forState:UIControlStateSelected];
            cell.payIcon.image =[UIImage imageNamed:@"icon_yuezhifu"];
            cell.payTypeLabel.text=@"现金支付";
            cell.payTypeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.payTypeLabel.textColor = RGB(51, 51, 51);
            cell.seletedButton.tag = 10000 +indexPath.row;
             if ([_isSeleButtonStr isEqualToString:@"现金支付"]){
                
                 cell.seletedButton.selected = YES;
            }
               return cell;
            
        }

    
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    orderDetailViewController *orederVC = [[orderDetailViewController alloc]init];
//    
//    OrderModel *orderModel = self.statusFrames[indexPath.section];
//    orederVC.OrderModel= orderModel;
//    [self.navigationController pushViewController:orederVC animated:YES];
    if (indexPath.section == 1 ){
        JYPayCouponViewController *vc = [[JYPayCouponViewController alloc] init];
        vc.BlockMineCouponVaule = ^(MineCouponModel *model) {
            _couponModel = model;
            if ([_couponModel isEqual:[NSNull null]] || _couponModel == nil) {
                _couponVaule = @"0";

            }else{
                
                _couponVaule = _couponModel.value;

            }
            if ([_isSeleButtonStr isEqualToString:@"现金支付"]){
                _isSeleButtonStr = @"";
            }
            [_tableView reloadData];
            
           
          NSString *coup =   _couponModel.value;
            double num = self.model.bid - [coup doubleValue];
            _totalMoney = [NSString stringWithFormat:@"%.2f",num];
            _payNumber.text = _totalMoney;
            if (num <= 0) {
                _payNumber.text = @"¥ 0";
                _totalMoney = @"0";
                _isPayMoneyZero = YES;
            }
          
            
        };
        [self.navigationController pushViewController:vc  animated:YES];
        
        
        
        
    }else if (indexPath.section == 2 ) {
        
        if (indexPath.row == 0) {
            
            
        }else{
            //点击选择哪种支付方式
      UIButton *button1 = (UIButton *)[self.view viewWithTag:10001];
      UIButton *button2 = (UIButton *)[self.view viewWithTag:10002];
      UIButton *button3 = (UIButton *)[self.view viewWithTag:10003];
      UIButton *button4 = (UIButton *)[self.view viewWithTag:10004];
            
            if (indexPath.row == button1.tag-10000) {
                
                button1.selected = YES;
                button4.selected = NO;
                button2.selected = NO;
                button3.selected = NO;
                _isSeleButtonStr = @"余额支付";
                
            }else if (indexPath.row == button2.tag- 10000){
            
                button1.selected = NO;
                button2.selected = YES;
                button3.selected = NO;
                button4.selected = NO;
                _isSeleButtonStr = @"支付宝支付";
            }else if (indexPath.row == button3.tag- 10000){
                
                button1.selected = NO;
                button2.selected = NO;
                button3.selected = YES;
                button4.selected = NO;
                _isSeleButtonStr = @"微信支付";
            }else{
            
                button1.selected = NO;
                button2.selected = NO;
                button3.selected = NO;
                button4.selected = YES;
                _isSeleButtonStr = @"现金支付";
                
                if ([_couponVaule isEqualToString:@"0"] != YES) {
                     button4.selected = NO;
                    [MBProgressHUD showInfoMessage:@"现金支付不能使用优惠券"];
                }
            }
         
        }

    }
    
    
}


@end
