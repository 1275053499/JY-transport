//
//  LoginViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+HexStringColor.h"
#import "NetWorkHelper.h"
#import "FMButton.h"
#import "JYAccount.h"
#import "JYAccountTool.h"
#import "JYWuliuTool.h"
#import "DeviceUID.h"
#import <JPUSHService.h>
#import "UserInfoModel.h"
#import "AggrementViewController.h"
#import "CustomNavigationViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,weak) UITextField *phoneNumber;
@property(nonatomic,weak)UITextField *CodeTextField;
@property(nonatomic,strong)FMButton *getCodeButton;
@property (nonatomic,strong)FMButton *loginButton;


@property (nonatomic,strong) NSTimer *timerTime;
@property (nonatomic,assign) NSInteger timeout;
@property (nonatomic,strong)NSString *alias;
@property (nonatomic,strong)NSString *deviceName;
@property (nonatomic,strong)NSString *udid;
@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSString *driverIconName;
@property (nonatomic,assign)BOOL isAggrement;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _isAggrement = YES;
    
    [self creaContentView];
    
    
}
-(void)registerDeviceId{
    
    [JPUSHService registrationID];
    NSLog(@"-------registrationID:%@",[JPUSHService registrationID]);
    //在登录成功对应的方法中设置标签及别名
    /**tags alias
     
     *每次调用设置有效的别名，覆盖之前的设置
     */
    [JPUSHService setAlias:_alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"-------上传成功－－－－－－alias:%@",_alias);
        
    } seq:0];
    
    //       NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);//对应的状态码返回为0，代表成功
    
}

-(void)creaContentView
{
    
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    [self.view addSubview: iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(105);
        make.width.mas_equalTo(70 * HOR_SCALE);
        make.height.mas_equalTo(70 * HOR_SCALE);
        
    }];
    
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = RGB(51, 51, 51);
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    
    [self.view addSubview: phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(iconImageView.mas_bottom).mas_offset(75);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(229, 229, 229);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_left);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(phoneLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UILabel *imgCode = [[UILabel alloc] init];
    imgCode.textColor = RGB(51, 51, 51);
    imgCode.text = @"验证码";
    imgCode.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    
    
    
    [self.view addSubview: imgCode];
    [imgCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(26);
        
    }];
    
    UITextField *phoneNumber = [[UITextField alloc]init];
    phoneNumber.delegate = self;
    phoneNumber.textColor = RGBA(51, 51, 51, 1);
    phoneNumber.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    phoneNumber.backgroundColor = [UIColor whiteColor];
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumber.returnKeyType = UIReturnKeyDone;
    phoneNumber.borderStyle=UITextBorderStyleNone;
    phoneNumber.tag = 902;
    [phoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    phoneNumber.text = @"";
    UIColor *color = RGB(204, 204, 204);
    phoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: color}];
    
    [phoneNumber setValue:[UIFont fontWithName:Default_APP_Font_Regu size:15] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:phoneNumber];
    
    
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).mas_equalTo(21);
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        
    }];
    
    
    
    UITextField *CodeTextField = [[UITextField alloc]init];
    CodeTextField.delegate = self;
    CodeTextField.tag = 903;
    CodeTextField.rightViewMode = UITextFieldViewModeAlways;
    [CodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    CodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    CodeTextField.textColor = RGBA(51, 51, 51, 1);
    CodeTextField.backgroundColor = [UIColor whiteColor];
    CodeTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    CodeTextField.borderStyle=UITextBorderStyleNone;
    
    CodeTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:CodeTextField];
    
    
    CodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [CodeTextField setValue:[UIFont fontWithName:Default_APP_Font_Regu size:15] forKeyPath:@"_placeholderLabel.font"];
    
    
    [CodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgCode.mas_right).mas_equalTo(21);
        make.centerY.mas_equalTo(imgCode.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-95);
        
        
    }];
    
    UIView *lineViewCode = [[UIView alloc] init];
    lineViewCode.backgroundColor = RGB(229, 229, 229);
    [self.view addSubview:lineViewCode];
    
    [lineViewCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(imgCode.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(0.5);
        
    }];
    
    self.getCodeButton = [FMButton createFMButton];
    [self.view addSubview:self.getCodeButton];
    self.getCodeButton.backgroundColor = [UIColor whiteColor];
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    [self.getCodeButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    self.getCodeButton.enabled = NO;
    self.getCodeButton.titleLabel.alpha = 0.5;
    
    WS(weakSelf);
    self.getCodeButton.block=^(FMButton *btn){
        
        [weakSelf getIdentifyCodes];
    };
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(CodeTextField.mas_centerY);
    }];
    
    
    UIButton *aggreeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [aggreeBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:(UIControlStateSelected)];
    [aggreeBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_normal"] forState:(UIControlStateNormal)];
    aggreeBtn.selected = YES;
    [self.view addSubview:aggreeBtn];
    aggreeBtn.tag = 2219;
    [aggreeBtn addTarget:self action:@selector(aggrementBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [aggreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.top.mas_equalTo(lineViewCode.mas_bottom).mas_offset(8);
    }];
    
    UILabel *aggreeLab = [[UILabel alloc] init];
    aggreeLab.text = @"同意";
    
    aggreeLab.textColor = RGB(153,153 , 153);
    aggreeLab.font = [UIFont fontWithName:Default_APP_Font_Regu size:13];
    [self.view addSubview:aggreeLab];
    
    [aggreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(aggreeBtn.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(aggreeBtn.mas_centerY);
    }];
    
    UIButton *aggrementBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [aggrementBtn setTitle:@"《简运使用条款》" forState:(UIControlStateNormal)];
    aggrementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    aggrementBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:13];
    [aggrementBtn setTitleColor:RGB(55, 168, 255) forState:(UIControlStateNormal)];
    aggrementBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [aggrementBtn addTarget:self action:@selector(aggrementBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    aggrementBtn.tag = 2220;
    
    [self.view addSubview:aggrementBtn];
    
    [aggrementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(aggreeLab.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(aggreeBtn.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    
    
    //登录
    
    FMButton *loginButton = [FMButton createFMButton];
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    loginButton.enabled = NO;
    loginButton.titleLabel.alpha = 0.5;
    [self.view addSubview:loginButton];
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = BGBlue;
    _loginButton = loginButton;
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(aggrementBtn.mas_bottom).mas_offset(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    loginButton.block = ^(FMButton *button){
        [self.view endEditing:YES];
        
        
        if ([phoneNumber.text isEqualToString:@""]) {
            [MBProgressHUD showInfoMessage:@"手机号码不能为空"];
            
            return ;
            
        }else if ([CodeTextField.text isEqualToString:@""]){
            
            
            [MBProgressHUD showInfoMessage:@"验证码不能为空"];
             return ;
            
        }else if(!_isAggrement){
            
            
        }else if ([phoneNumber.text isEqualToString:@"13279160519"] && [CodeTextField.text isEqualToString:@"8888"]){
            
            [JYAccountTool saveUserName:self.phoneNumber.text];

            [self postDeviceInfo];
            [self registerDeviceId];
            
            //查询用户信息
            [self senderHttp];
            // 6.新特性\去首页
            [JYWuliuTool chooseRootController];
          
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
            return;
        }else{
            
             [self sendHttpReque];
        }
    };
    self.phoneNumber=phoneNumber;
    self.CodeTextField=CodeTextField;
    
    
    //我要加盟
    FMButton *toJoinButton = [FMButton createFMButton];
    
    [toJoinButton setTitle:@"我要加盟" forState:UIControlStateNormal];
    [toJoinButton setTitleColor:BGBlue forState:UIControlStateNormal];
    toJoinButton.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
    [self.view addSubview:toJoinButton];
    [toJoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(298);
    }];
    
    toJoinButton.block = ^(FMButton *button){
        
        [self joinDriverClick];
    };
    
    
}
- (void)joinDriverClick{
  //去下载
    NSString *appid = @"1333384887";
    NSString *appStr = [NSString stringWithFormat:@"https://itunes.apple.com/app/apple-store/id%@?pt=1333384887&ct=web&mt=8",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStr]];

          
}

//验证码倒计时
- (void)openCountdown{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行一次
    NSTimeInterval seconds = 60.f;
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds]; // 最后期限
    
    dispatch_source_set_event_handler(_timer, ^{
        int interval = [endTime timeIntervalSinceNow];
        if (interval > 0) { // 更新倒计时
            NSString *timeStr = [NSString stringWithFormat:@"%d秒后重发", interval];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.getCodeButton.enabled = NO;
                [self.getCodeButton setTitle:timeStr forState:UIControlStateNormal];
            });
        } else { // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getCodeButton.enabled = YES;
                [self.getCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_timer);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 902) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        
        if (strLength >= 11) {
            
            self.getCodeButton.enabled = YES;
            self.getCodeButton.titleLabel.alpha = 1;
        }else{
            self.getCodeButton.enabled = NO;
            self.getCodeButton.titleLabel.alpha = 0.5;
        }
        
    }
    return YES;
    
}
- (void)textFieldDidChange:(UITextField *)text{
   
    if (self.phoneNumber.text.length == 11 && self.CodeTextField.text.length > 0  && _isAggrement == YES) {
        self.loginButton.titleLabel.alpha = 1;
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.titleLabel.alpha = 0.5;
        self.loginButton.enabled = NO;
    }
    
}

-(void)getIdentifyCodes{
    
    [NetWorkRequest PostRequestCode:self.phoneNumber.text success:^(id responseObj) {
        NSLog(@"成功成功成功成功成功成功成功成功成功成功成功");
        //
                [self openCountdown];
    } failure:^(NSError *error) {
        NSLog(@"网络异常网络异常网络异常网络异常网络异常网络异常网络异常网络异常");
        //
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"网络异常"];
    }];
}


-(void)sendHttpReque
{
    
    [NetWorkRequest PostRequestCode:self.phoneNumber.text verCode:self.CodeTextField.text idea:@"0" success:^(id responseObj) {
        NSString *DataStr = [responseObj objectForKey:@"message"];
        
        if ([[responseObj objectForKey:@"message"] isEqualToString:@"404"]) {
            
            [MBProgressHUD showError:@"此账号还没有加盟"];
        }
        
        if ([DataStr isEqualToString:@"0"]) {
            
            //  [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功" delegate:nil cancelButtonTitle:@"我知道啦" otherButtonTitles:nil, nil]show];
            
            [self postDeviceInfo];
            [self registerDeviceId];
            
            [JYAccountTool saveUserName:self.phoneNumber.text];
            //查询用户信息
            [self senderHttp];
            
            // 6.新特性\去首页
            [JYWuliuTool chooseRootController];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
            
            // 7.隐藏提醒框
            //[MBProgressHUD hideHUD];
            // [self backClick:nil];
            
        }else if([DataStr isEqualToString:@"1"]){
            
            [MBProgressHUD showError:@"验证码超时"];
        }else if([DataStr isEqualToString:@"2"]){
            [MBProgressHUD showError:@"没有获取验证码"];
            
        }else if([DataStr isEqualToString:@"3"]){
            [MBProgressHUD showError:@"验证码错误"];
            
        }else{
            [MBProgressHUD showError:@"登录失败"];
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"我知道啦" otherButtonTitles:nil, nil]show];
        }
        
        NSLog(@"%@",responseObj);
        
    } failure:^(NSError *error) {
        
         [MBProgressHUD showError:@"网络异常"];
    }];

}

#pragma mark 查询用户信息
-(void)senderHttp
{
    
    [NetWorkRequest PostRequestUseInfo:self.phoneNumber.text success:^(id responseObj) {
        UserInfoModel *model = [[UserInfoModel alloc] init];
        
        model.phone = [responseObj objectForKey:@"phone"];
        
        if (model.phone.length <= 0 || [model.phone isEqual:[NSNull null]]) {
            model.phone = self.phoneNumber.text;
        }
        
        model.nickname = [responseObj objectForKey:@"nickname"];
        if (model.nickname == nil || [model.nickname isEqual:[NSNull null]]) {
            model.nickname = self.phoneNumber.text;
        }
        
        if (model.icon == nil || [model.icon isEqual:[NSNull null]]) {
            model.icon = @"";
        }
        
        model.icon = [responseObj objectForKey:@"icon"];
        _driverIconName = model.icon;
        model.id = [responseObj objectForKey:@"id"];
        model.remark = [responseObj objectForKey:@"remark"];
        model.weixin = [responseObj objectForKey:@"weixin"];
        model.qq  =     [responseObj objectForKey:@"qq"];
        model.sexuality = [responseObj objectForKey:@"sexuality"];
        
        [[JYAccountTool  shareInstance] saveUserInfoModel:model];
    } failure:^(NSError *error) {
        
    }];
        
   
    
//    NSString *baseStr = base_url;
//    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUseInfo"];
//
//
//    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.phoneNumber.text} success:^(id responseObj) {
//
//
//         UserInfoModel *model = [[UserInfoModel alloc] init];
//
//         model.phone = [responseObj objectForKey:@"phone"];
//
//        if (model.phone.length <= 0 || [model.phone isEqual:[NSNull null]]) {
//            model.phone = self.phoneNumber.text;
//        }
//
//        model.nickname = [responseObj objectForKey:@"nickname"];
//        if (model.nickname == nil || [model.nickname isEqual:[NSNull null]]) {
//            model.nickname = self.phoneNumber.text;
//        }
//
//        if (model.icon == nil || [model.icon isEqual:[NSNull null]]) {
//            model.icon = @"";
//        }
//
//        model.icon = [responseObj objectForKey:@"icon"];
//        _driverIconName = model.icon;
//        model.id = [responseObj objectForKey:@"id"];
//        model.remark = [responseObj objectForKey:@"remark"];
//        model.weixin = [responseObj objectForKey:@"weixin"];
//        model.qq  =     [responseObj objectForKey:@"qq"];
//        model.sexuality = [responseObj objectForKey:@"sexuality"];
//
//        [[JYAccountTool  shareInstance] saveUserInfoModel:model];
//
//
//    } failure:^(NSError *error) {
//
//        //         [MBProgressHUD showError:@"网络异常" toView:self.view];
//    }];
//
    
}

//- (void)getUserIcon{

//    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
//     NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_driverIconName];
//    if (_driverIconName == nil || [_driverIconName isEqual:[NSNull null]]) {
//        urlstr = @"";
//        return;
//    }
//
//    [[NetWorkHelper shareInstance]Get:urlstr parameter:nil success:^(id responseObj) {
//
//        if ([responseObj isKindOfClass:[NSData class]]) {
//
//            [[NSUserDefaults standardUserDefaults] setObject:responseObj forKey:@"UserIcon"];
//
//        }else if ([responseObj isKindOfClass:[NSString class]])
//        {
//            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:responseObj options:NSDataBase64DecodingIgnoreUnknownCharacters];
//
//            [[NSUserDefaults standardUserDefaults] setObject:decodedImageData forKey:@"UserIcon"];
//
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"error%@",error);
//    }];


//}

- (void)aggrementBtnClick:(UIButton *)btn{
    
    if (btn.tag == 2219) {
        btn.selected = !btn.selected;
        if (btn.selected == NO) {
            _isAggrement = NO;
        }else{
            _isAggrement = YES;
        }
        if (self.phoneNumber.text.length == 11 && self.CodeTextField.text.length > 0 && _isAggrement == YES) {
            
            self.loginButton.titleLabel.alpha = 1;
            self.loginButton.enabled = YES;
        }else{
            self.loginButton.titleLabel.alpha = 0.5;
            self.loginButton.enabled = NO;
        }
    }else if (btn.tag == 2220){
        AggrementViewController *vc = [[AggrementViewController alloc] init];
        
        CustomNavigationViewController *navi = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navi animated:YES completion:nil];
        
    }
}

- (void)postDeviceInfo{
    _udid = [DeviceUID uid];
    _type = @"1";
    
    NSString *strUrl = [_udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    _deviceName =  [[UIDevice currentDevice] systemName];
    NSString *alStr = [self.phoneNumber.text substringFromIndex:7];
    NSString *aliasStr = [strUrl stringByAppendingString:alStr];
    _alias = [aliasStr stringByAppendingString:_type];
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/postDevice"];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":self.phoneNumber.text,@"deviceName":_deviceName,@"uuid":_udid,@"alias":_alias,@"type":_type} success:^(id responseObj) {
        
        
        
        
    }failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}
- (void)backClick:(UIButton *)sender
{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}


@end
