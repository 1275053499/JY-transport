//
//  PasswordViewController.m
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.


#import "PasswordViewController.h"
#import "TMPassWordView.h"
#import "NSString+Hash.h"



@interface PasswordViewController ()<TMTextFieldViewDelegate>

@property (nonatomic,strong)TMPassWordView *pwdOldView;
@property (nonatomic,strong)TMPassWordView *pwdNewView;

/**
 *  第一次输入的密码
 */
@property(nonatomic,copy)NSString *firstCode;
@property (nonatomic,assign)BOOL isCheckSuccess;


@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _isCheckSuccess = NO;
    _firstCode = @"";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];

   
    [self setDateFromType];
    [self creatsubview];
   
}

-(void)creatsubview
{

    if (_passwordType == PassWordTypeChange) {
   
        self.pwdOldView = [[TMPassWordView alloc] initWithFrame:CGRectMake(0, 160, ScreenWidth, 120) WithDelegate:self];
                       
    self.pwdOldView.backgroundColor = BgColorOfUIView;
    self.pwdOldView.title = @"请输入支付密码，以验证身份";
    [self.view addSubview: self.pwdOldView];
    [self.pwdOldView.textFieldView.pwdTextField becomeFirstResponder];
    
    }else{
        [self creatNewPasswordView];
        self.pwdNewView.frame = CGRectMake(0, 160, ScreenWidth, 120);

    }
   
}
- (void)creatNewPasswordView{
    self.pwdNewView = [[TMPassWordView alloc] initWithFrame: CGRectMake(ScreenWidth, 160, ScreenWidth, 120) WithDelegate:self];
    
    self.pwdNewView.title = @"请设置支付密码";
    self.pwdNewView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.pwdNewView];

    [self.pwdNewView.textFieldView.pwdTextField becomeFirstResponder];
}
- (void)setDateFromType{
    
    if (_passwordType == PassWordTypeChange) {
        self.navigationItem.title =@"修改密码";
        
    }else if (_passwordType == PassWordTypeSetNew){
       
        self.navigationItem.title =@"设置密码";

    }
}

- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//设置密码
- (void)setThePassword:(NSString *)str{
    //idea（0用户1司机2物流）
    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:@"app/wallet/setThePassword"];
    NSString *phone = userPhone;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"pwd":str,@"idea":@"0"} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            [MBProgressHUD showSuccess:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
      
    } failure:^(NSError *error) {
        
        [MBProgressHUD showSuccess:@"网络异常"];

        
    }];
}

//校验密码
- (void)checkThePassword:(NSString *)str{
    //idea（0用户1司机2物流）
    NSString *urls = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urls stringByAppendingString:@"app/wallet/checkThePassword"];
    NSString *phone = userPhone;
  
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"pwd":str,@"idea":@"1"} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            [MBProgressHUD hideHUD];
            _isCheckSuccess = YES;
            [self creatNewPasswordView];
            
            [UIView animateWithDuration:0.5 animations:^{

                self.pwdNewView.frame = CGRectMake(0, 160, ScreenWidth, 120);


            } completion:^(BOOL finished) {

//                self.pwdOldView.delegate = nil;
                [self.pwdOldView removeFromSuperview];
                [self.pwdNewView becomeFirstResponder];

            }];
           
 
        }else{
            _isCheckSuccess = NO;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"密码错误，请重试"];
            [self.pwdOldView deleteAllPassWords];

          

        }
        
        
    } failure:^(NSError *error) {

        [MBProgressHUD hideHUD];
        _isCheckSuccess = NO;

        [MBProgressHUD showError:@"失败"];
        
    }];
}



/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(TMTextFieldView *)passWord{
    NSLog(@" 监听输入的完成时========%@======",passWord.pwdPassword);

    NSString *pwd = passWord.pwdPassword;
    if (_passwordType == PassWordTypeSetNew) {

        [self enterCode:pwd];
        [self.pwdNewView deleteAllPassWords];

    }else if (_passwordType == PassWordTypeChange){

        if (_isCheckSuccess == NO) {

            [self changePassworld:pwd];

        }else{
            
             [self enterCode:pwd];
             [self.pwdNewView deleteAllPassWords];
        }
       
        
    }

}


-(void)enterCode:(NSString *)code
{
    if ([self.firstCode isEqualToString:@""]) {
        self.firstCode = code;
        self.pwdNewView.title = @"请再次输入支付密码";


    } else if ([self.firstCode isEqualToString:code]){
        NSString *pwdCode =  [self encrybtion:code];
        [self setThePassword:pwdCode];
    } else {
        self.pwdNewView.title=@"您两次输入的密码不匹配，请重新设置";
        self.firstCode = @"";
    }
    
}
- (NSString *)encrybtion:(NSString *)code{
    
  NSString * pwdStr = [code stringByAppendingString:salt];
    NSString *pwdStrCode = pwdStr.md5String;
    return pwdStrCode;
}
- (void)changePassworld:(NSString *)pwd{
    [MBProgressHUD showActivityMessageInWindow:@"正在验证"];
  
    NSString *pwdCode = [self encrybtion:pwd];
    [self checkThePassword:pwdCode];
}


-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
