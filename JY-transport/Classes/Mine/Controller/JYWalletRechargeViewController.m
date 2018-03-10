//
//  JYWalletRechargeViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWalletRechargeViewController.h"
//#import "PopPasswordView.h"
#import "WithdrawTypeCell.h"
#import "WithdrawTableViewCell.h"
#import "PayMoneyManager.h"
typedef enum{
    
    PayTypeAliPay = 1,
    PayTypeWeChat = 2,
    
}PayType;

@interface JYWalletRechargeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *moneyText;

@property (nonatomic,assign)PayType payType;
@end

@implementation JYWalletRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    _payType = 0;
    _moneyText = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alPaySuccess:) name:@"alPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPaySuccess:) name:@"WXPaySuccess" object:nil];
    
    self.navigationItem.title = @"充值";
    
    [self createTableView];
    
}
- (void)WXPaySuccess:(NSNotification *)noti{
    
    [self PaySuccess:@"微信"];
}

- (void)alPaySuccess:(NSNotification *)noti{
    
     [self PaySuccess:@"支付宝"];
}
- (void)PaySuccess:(NSString *)payty{

    
    [MBProgressHUD showSuccess:@"充值成功"];
    NSString *base = base_url;
    NSString *url = [base stringByAppendingString:@"app/wallet/wallSuccess"];
    NSString *phone = userPhone;
    
    NSDictionary *dic = @{@"status":@"200",@"totalAmount":_moneyText,@"phone":phone,@"outTradeNo":@"1",@"payType":payty};
    
    [[NetWorkHelper shareInstance] Post:url parameter:dic success:^(id responseObj) {
        NSLog(@"-------");
    } failure:^(NSError *error) {
    
    }];
}

-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 50;
    }else{
        if (indexPath.row == 0) {
            return 90;
        }else{
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        WithdrawTypeCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WithdrawTypeCell class]) owner:nil options:0][0];
        cell.imgType.image = [UIImage imageNamed:@"icon_zhifubao"];
        //        cell.chooseAccountLabel.text = @"";
        cell.chooseAccountLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:12];
        cell.chooseAccountLabel.textColor = RGB(102, 102, 102);
        cell.accessImg.image = [UIImage imageNamed:@"no_making_tick"];
        cell.accessImg.tag = 400 + indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (indexPath.row == 0) {
            cell.contentlabel.text = @"支付宝支付";
            cell.imgType.image = [UIImage imageNamed:@"icon_zhifubao"];
            if (_payType == PayTypeAliPay) {
                
                cell.accessImg.image = [UIImage imageNamed:@"making_tick"];
            }
            
        }else{
            cell.contentlabel.text = @"微信支付";
            cell.imgType.image = [UIImage imageNamed:@"icon_weixinzhifu"];
            if (_payType == PayTypeWeChat){
                cell.accessImg.image = [UIImage imageNamed:@"making_tick"];
                
            }
            
        }
        
        return cell;
    }else{
        
        WithdrawTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WithdrawTableViewCell class]) owner:nil options:0][0];
        
        [cell.moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.moneyTextField.tag = 356;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moneyTextField.returnKeyType = UIReturnKeyDone;
        cell.moneyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.moneyTextField.delegate = self;
        cell.moneyTextField.text = _moneyText;
        
        cell.type.text =  @"充值";
        
        return cell;
        
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITextField *textField = [self.view viewWithTag:356];
    if (_moneyText.length <= 0) {
        
        [textField becomeFirstResponder];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    if (section == 0) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        nameLabel.text = @"请选择支付类型";
        nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:12];
        nameLabel.textColor = RGB(102, 102, 102);
        [v addSubview:nameLabel];
        
    }
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else{
        return 9;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 120;
    }else{
        return 0.01;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    v.backgroundColor = BgColorOfUIView;
    if (section == 1) {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(15, 120 - 50, ScreenWidth -30, 50);
        [btn setTitle:@"完成" forState:(UIControlStateNormal)];
        btn.tag = 357;
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn.backgroundColor =  RGB(105, 181, 240);
        btn.enabled = NO;
        if (_payType != 0 && _moneyText.length > 0) {
            btn.backgroundColor =  BGBlue;
            btn.enabled = YES;
        }
        
        [btn addTarget:self action:@selector(finishClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        [v addSubview:btn];
    }
    
    return v;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIImageView *imgView1 = [self.view viewWithTag:400];
    UIImageView *imgView2 = [self.view viewWithTag:401];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            imgView2.image = [UIImage imageNamed:@"no_making_tick"];
            imgView1.image = [UIImage imageNamed:@"making_tick"];
            _payType = PayTypeAliPay;
        }else{
            imgView1.image = [UIImage imageNamed:@"no_making_tick"];
            imgView2.image = [UIImage imageNamed:@"making_tick"];
            _payType =PayTypeWeChat;
        }
        
    }
    
    UIButton *btn = [self.view viewWithTag:357];
    if (_payType != 0  && _moneyText.length > 0) {
        btn.backgroundColor =  BGBlue;
        btn.enabled = YES;
    }else{
        btn.backgroundColor = RGB(105, 181, 240); ;
        btn.enabled = NO;
    }
    
    
}
//充值成功
- (void)finishClick:(UIButton *)btn{
    
    PayMoneyManager *manager = [[PayMoneyManager alloc] init];
    
    if (_payType == PayTypeAliPay) {
        
        [manager payMoneyAlipayHttp:_moneyText payType:@"ailPay"];
        
    }else if (_payType == PayTypeWeChat){
        
        [manager payMoneyForWechat:_moneyText payType:@"wechatPay"];
        
    }
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    UIButton *nextBtn = [self.view viewWithTag:357];
    
    _moneyText = theTextField.text;
    if (_moneyText.length > 0 && _payType != 0) {
        nextBtn.backgroundColor = BGBlue;
        nextBtn.enabled = YES;
    }else{
        nextBtn.backgroundColor = RGB(105, 181, 240);
        nextBtn.enabled = NO;
        
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 356) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        //首位不能为.号
        if (range.location == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        return [self isRightInPutOfString:textField.text withInputString:string range:range];
        return NO;
        
    }else{
        return YES;
    }
    
}
- (BOOL)isRightInPutOfString:(NSString *)string withInputString:(NSString *) inputString range:(NSRange) range{
    //判断只输出数字和.号
    NSString *passWordRegex = @"[0-9\\.]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:inputString]) {
        return NO;
    }
    //逻辑处理
    if ([string containsString:@"."]) {
        if ([inputString isEqualToString:@"."]) {
            return NO;
        }
        NSRange subRange = [string rangeOfString:@"."];
        if (range.location - subRange.location > 2) {
            return NO;
        }
    }
    
    if (string.length >= 8) {
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
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
