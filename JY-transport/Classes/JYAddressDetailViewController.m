//
//  JYAddressDetailViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYAddressDetailViewController.h"
#import "JYAddressDetailTableViewCell.h"
#import "JYMyAddressViewController.h"
#import "UserInfoModel.h"
#import "JYWaitingAnimationViewController.h"
#import <IQKeyboardManager.h>
#import "JYHomeRequestDate.h"
#import "JYOrderDetailViewController.h"
@interface JYAddressDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JYHomeRequestDateDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UserInfoModel *userModel;
@property (nonatomic,strong)NSString *senderName;
@property (nonatomic,strong)NSString *senderPhone;
@property (nonatomic,strong)NSString *senderAddress;
@property (nonatomic,strong)NSString *recipientsName;
@property (nonatomic,strong)NSString *recipientsPhone;
@property (nonatomic,strong)NSString *recipientsAddress;

@end

@implementation JYAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"详情补充";
    self.view.backgroundColor = BgColorOfUIView;
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    _senderName = _userModel.nickname;
    _senderPhone = userPhone;
    _senderAddress = @"";
    _recipientsName = @"";
    _recipientsPhone = @"";
    _recipientsAddress = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SureOrderPrice:) name:@"SureOrder" object:nil];

    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    
    JYWaitingAnimationViewController *animationVC =(JYWaitingAnimationViewController *) self.parentViewController;
    if ([animationVC isKindOfClass:[JYWaitingAnimationViewController class]]) {
        
        _address = animationVC.startProvice;
        _addressSend = animationVC.endProvice;
        _orderID = animationVC.orderID;
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

    }
    
    

}
- (void)viewDidDisappear:(BOOL)animated{
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

}
- (void)SureOrderPrice:(NSNotification *)noti{
    
    [self requestAddress];

}

- (void)surePriceBtnClick:(UIButton *)btn{
    
    [self requestAddress];
}

- (void)requestAddress{
    
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate =self;
    NSDictionary *dic = @{@"orderId":_orderID,@"senderName":_senderName,@"senderPhone":_senderPhone,@"senderAddress":_senderAddress,@"recipientsName":_recipientsName,@"recipientsAddress":_recipientsAddress,@"recipientsPhone":_recipientsPhone};
    NSString *phone = userPhone;
    [manager requsetConfirmationAddress:@"app/logisticsorder/submitAdditional" orderInfo:dic phone:phone];
}

- (void)requsetConfirmationAddressSuccess:(NSDictionary *)resultDic{
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        
        JYOrderDetailViewController *vc =[[JYOrderDetailViewController alloc] init];
        vc.orderID = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}
- (void)requsetConfirmationAddressFailed:(NSError *)error{
    
    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight- 64 - 50-118) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BgColorOfUIView;
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 64 -50,ScreenWidth, 50);
    sureBtn.backgroundColor = BGBlue;
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(surePriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 198;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYAddressDetailTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYAddressDetailTableViewCell class]) owner:nil options:0][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.lookAddressBtn addTarget:self action:@selector(lookAddressBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.nameTextField.delegate = self;
    cell.phoneTextField.delegate = self;
    cell.addressDetailTextField.delegate = self;
   

    [cell.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.addressDetailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    cell.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    cell.nameTextField.returnKeyType = UIReturnKeyDone;
    cell.phoneTextField.returnKeyType = UIReturnKeyDone;
    cell.addressDetailTextField.returnKeyType = UIReturnKeyDone;

    [cell setTextFieldColorAndFont];
      
       if (indexPath.section == 0) {
           cell.iconType.image = [UIImage imageNamed:@"icon_jijian"];
           cell.lookAddressBtn.tag = 296;
           cell.nameTextField.text = _senderName;
           cell.phoneTextField.text = _senderPhone;
           cell.addressLabel.text = _addressSend;
           cell.addressDetailTextField.text = _senderAddress;
           cell.nameTextField.tag = 231;
           cell.phoneTextField.tag = 232;
           cell.addressDetailTextField.tag = 233;

    }else{
        
        cell.addressLabel.text = _address;
        cell.lookAddressBtn.tag = 297;
        cell.nameTextField.text = _recipientsName;
        cell.phoneTextField.text = _recipientsPhone;
        cell.addressDetailTextField.text = _recipientsAddress;
        cell.iconType.image = [UIImage imageNamed:@"icon_shoujian"];
        cell.nameTextField.tag = 234;
        cell.phoneTextField.tag = 235;
        cell.addressDetailTextField.tag = 236;
        
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

- (void)lookAddressBtnClick:(UIButton *)btn{
    
    JYMyAddressViewController *vc = [[JYMyAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    switch (textField.tag) {
        case 231:
            
            _senderName = textField.text;
            break;
        case 232:
            
            _senderPhone = textField.text;
            break;
        case 233:
            
            _senderAddress = textField.text;
            break;
        case 234:
            
            _recipientsName = textField.text;

            break;
        case 235:
            
            _recipientsPhone = textField.text;

            break;
        case 236:
            
            _recipientsAddress = textField.text;

            break;
            
        default:
            break;
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SureOrder" object:nil];
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
