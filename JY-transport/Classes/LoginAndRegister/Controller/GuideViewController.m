//
//  GuideViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "GuideViewController.h"
#import "CustomTabBarViewController.h"
#import "UserInfoModel.h"
@interface GuideViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIButton *loginButton;
    NSInteger imageCount;
    NSArray *imageArray;
    UIButton *jumpButton;
    UIImageView *pageView;
}
@property (nonatomic,strong)UILabel *lab;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)UITextField *textField;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = @[@"Guidepage1",@"Guidepage2",@"Guidepage3",@"Guidepage4"];
    imageCount = imageArray.count;
    [self initSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return self;
}

-(void)initSubviews
{
   
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.pagingEnabled=YES;
    scrollView.bounces=NO;
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    pageView = [[UIImageView alloc] init];
    pageView.image = [UIImage imageNamed:@"pagecontrol0"];
    pageView.frame = CGRectMake((scrollView.frame.size.width - 90)/2, scrollView.frame.size.height - 30, 90, 9);
    
    [self.view addSubview:pageView];
    
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:223.0/255.0 green:48.0/255.0 blue:49.0/255.0 alpha:1.0];
    _pageControl.currentPage=0;
//    [self.view bringSubviewToFront:_pageControl];
    
    jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpButton.frame = CGRectMake(ScreenWidth - 60 - 15, 27, 55 * HOR_SCALE, 25);
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    jumpButton.layer.cornerRadius =  (jumpButton.frame.size.height)/2;
    jumpButton.layer.masksToBounds = YES;
//    jumpButton.layer.borderColor= BGBlue.CGColor;
//    jumpButton.layer.borderWidth= 0.5;
//
    jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
    jumpButton.backgroundColor = [UIColor whiteColor];
    jumpButton.hidden = NO;
    [jumpButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [jumpButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame=CGRectMake((ScreenWidth-280 * HOR_SCALE)/2, ScreenHeight- 60, 280 * HOR_SCALE, 40);
    [loginButton setTitle:@"立即体验" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 20;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    loginButton.backgroundColor = [UIColor whiteColor];
    loginButton.hidden = YES;
    [loginButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    [self showImages];
}

-(void)showImages
{
    scrollView.contentSize=CGSizeMake(ScreenWidth*([imageArray count]), ScreenHeight-StateBarHeight);
    _pageControl.numberOfPages=imageCount;
    for (NSInteger i=0;i<[imageArray count];i++)
    {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
        imageView.image=ImageNamed([imageArray objectAtIndex:i]);
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds  = YES;
        [scrollView addSubview:imageView];
    }
   
}

//-(void)autoScrollImage
//{
//    NSInteger currentPage=floor((scrollView.contentOffset.x-scrollView.frame.size.width/(imageCount+2))/scrollView.frame.size.width)+1;
//
//    if (currentPage==imageCount)
//    {
//        [scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, ScreenHeight) animated:NO];
//        [scrollView scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight) animated:YES];
//    }
//    else
//    {
//        float x = ScreenWidth*(currentPage+1);
//        [scrollView scrollRectToVisible:CGRectMake(x, 0, ScreenWidth, ScreenHeight) animated:YES];
//    }
//
//    NSInteger offsetIndex=scrollView.contentOffset.x/320;
//    if (offsetIndex==imageCount)
//    {
//        offsetIndex=0 ;
//    }
//    else if(offsetIndex==0)
//    {
//        offsetIndex=0 ;
//    }
//    _pageControl.currentPage=offsetIndex;
//}

#pragma -mark UIScrollViewDelegate  代理

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    int currentPage = round(scrollView.contentOffset.x/ScreenWidth);
    pageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pagecontrol%ld",(long) currentPage]];
    if (currentPage == imageCount - 1) {
        loginButton.hidden = NO;
        jumpButton.hidden = YES;
        
    }else{
        loginButton.hidden = YES;
        jumpButton.hidden = NO;
        
        
    }

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)login:(id)sender
{

    [self senderHttp];
    [_maskView removeFromSuperview];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].keyWindow.rootViewController = [[CustomTabBarViewController alloc] init];
}
-(void)senderHttp
{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUseInfo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":userPhone} success:^(id responseObj) {
        
              _userId = [responseObj objectForKey:@"id"];
        
        _userName = [responseObj objectForKey:@"nickname"];
        if (_userName == nil  || [_userName isKindOfClass:[NSNull class]] || _userName.length <= 0) {
            
            _userName = userPhone;
            
            [self performSelector:@selector(updateUserName) withObject:nil afterDelay:0.1];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
    
    
}
- (void)updateUserName{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/updateUserInfo"];
    if (_userId == nil || _userName == nil || [_userName isEqual:[NSNull null]] ||[_userId isEqual:[NSNull null]]) {
        
        return;
    }
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":_userId,@"nickname":_userName} success:^(id responseObj) {
        NSString *statu =  [responseObj objectForKey:@"message"];
        if ([statu isEqualToString:@"0"]) {
         
         UserInfoModel *model = [[JYAccountTool shareInstance] getUserInfoModelInfo];
           
            model.nickname = _userName;
            
            [[JYAccountTool shareInstance] saveUserInfoModel:model];
          

        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];

}

- (void)setUserName{
    
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 250) / 2, (ScreenHeight - 400) / 2, 250, 165)];
    superView.backgroundColor = [UIColor whiteColor];
    superView.layer.cornerRadius = 12;
    superView.layer.masksToBounds = YES;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 1;
    tipLabel.text = @"请输入昵称";
    tipLabel.font = [UIFont systemFontOfSize:17];
    [superView addSubview:tipLabel];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 240, 40)];
    
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = @"请输入昵称，8个字符以内";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.font  = [UIFont systemFontOfSize:15];
    [_textField becomeFirstResponder];
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [superView addSubview:_textField];
    
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 250, 30)];
    _lab.text = @"昵称只能由中文、字母或数字组成";
    _lab.font = [UIFont systemFontOfSize:14];
    _lab.textColor = [UIColor redColor];
    _lab.hidden = YES;
    [superView addSubview:_lab];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _maskView.backgroundColor =  RGBA(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    [_maskView addSubview:superView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 250, 1)];
    line.backgroundColor = BgColorOfUIView;
    [superView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 120, 250, 45);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview: btn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidChange:(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    _userName = theTextField.text;
    BOOL name = [self saveDateNickname:theTextField.text];
    if (!name) {
         _lab.hidden = NO;
 
    }else{
        _lab.hidden = YES;
    }
    if (theTextField.text.length == 0) {
        _lab.hidden = YES;
    }
}
- (BOOL)saveDateNickname:(NSString *)nickname {
    
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{0,7}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:nickname];
    return inputString;
}


@end
