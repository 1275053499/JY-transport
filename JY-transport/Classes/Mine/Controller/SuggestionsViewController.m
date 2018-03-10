//
//  SuggestionsViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SuggestionsViewController.h"

@interface SuggestionsViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextView *textView;

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    [self creatTextView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatTextView{
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(4, 1, 300, 35)];
    _label.textColor = RGB(153, 153, 153);
    _label.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    _label.text = @"请填写您宝贵意见，让我们不断进步，谢谢";
    _label.enabled = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor lightGrayColor];
 
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth - 30, 200)];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
   
    [_textView addSubview:_label];
    _textView.delegate = self;
    [bottomView addSubview:_textView];
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.backgroundColor = BGBlue;
    finishBtn.frame =CGRectMake(15, 250, ScreenWidth - 30, 50);
    [finishBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.layer.cornerRadius = 5;
    finishBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:finishBtn];

    
}

- (void)finishBtnClick:(UIButton *)btn{
    
    [self postContent];
}
-(void)postContent{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/feedback/saveFeedback/"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":userPhone,@"remark":_textView.text} success:^(id responseObj) {

        
//        if ([responseObj integerValue] == 0 ) {
        NSLog(@"提交评价成功%@",responseObj);
        
        [MBProgressHUD showSuccess:@"提交成功"];
        [self performSelector:@selector(returnAction) withObject:nil afterDelay:0.5];

//        }
      
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];

    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_label setHidden:NO];
        
    }else{
        [_label setHidden:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
