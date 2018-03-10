//
//  EditPersonalNameVC.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EditPersonalNameVC.h"

@interface EditPersonalNameVC ()<UITextFieldDelegate>


@property (nonatomic,strong)UITextField *nameTextField;

@end

@implementation EditPersonalNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"修改昵称";
    
    [self creatTextField];
    UIBarButtonItem *rightItem =  [UIBarButtonItem addRight_ItemWithTitle:@"保存" target:self action:@selector(saveName)];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    
    _nameTextField.text = _nickName;
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)creatTextField{
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 8, ScreenWidth, 50)];
    _nameTextField.delegate = self;
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    [_nameTextField round:2.0 RectCorners:(UIRectCornerAllCorners)];
    
    
    _nameTextField.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon_shangchu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _nameTextField.rightView = button;
    _nameTextField.rightViewMode = UITextFieldViewModeAlways;
    
    //以下代码为了让光标右移
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _nameTextField.leftView = leftView;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nameTextField];
    [_nameTextField becomeFirstResponder];
    
}
- (void)buttonClick:(UIButton *)btn{
    
    _nameTextField.text = @"";
}
- (void)saveName{
  BOOL name = [self saveDateNickname:_nameTextField.text];
    if (name) {
        if ([self.delegate respondsToSelector:@selector(changeNameValue:)]) {
            [self.delegate changeNameValue:_nameTextField.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self prentTip];
    }
   
}
- (void)prentTip{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"昵称只能由中文、字母或数字组成" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

}
- (BOOL)saveDateNickname:(NSString *)nickname {
    
//    NSString *regex =@"[\u4e00-\u9fa5]+[A-Za-z0-9]{6,20}+$";
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{0,7}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:nickname];
    return inputString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
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
