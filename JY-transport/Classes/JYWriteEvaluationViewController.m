//
//  JYWriteEvaluationViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWriteEvaluationViewController.h"
#import "HCSStarRatingView.h"
#import "CpTextView.h"
#import "JYMessageRequestData.h"
@interface JYWriteEvaluationViewController ()<HCSStarRatingViewDelegate,UITextViewDelegate,JYMessageRequestDataDelegate>

@property (nonatomic,strong)UIView *SupView;
@property (nonatomic,strong)HCSStarRatingView *starRatingView;
@property (nonatomic,strong)NSString *speedScore;
@property (nonatomic,strong)NSString *attitudeScore;
@property (nonatomic,strong)NSString *evComment;
@end

@implementation JYWriteEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _speedScore = @"5";
    _attitudeScore = @"5";
    _evComment = @"";
    [self creatView];

}
- (void)creatView{
    
 UIView *SupView =  [[UIView alloc] initWithFrame:CGRectMake(0, 9, ScreenWidth, ScreenHeight - 64 -50)];
    SupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SupView];
    SupView.backgroundColor = [UIColor whiteColor];
    
    [SupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(9);
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset( - 59);
    }];
    
    [SupView rounded:2.0];
   _SupView = SupView;
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_touxiang"];
    [SupView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(SupView.mas_top).mas_offset(24);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(0);
        
    }];
    
    UILabel *labName = [[UILabel alloc] init];
    labName.text = @"哈哈哈哈";
    labName.textAlignment = NSTextAlignmentCenter;
    labName.font =  [UIFont fontWithName:Default_APP_Font_Regu size:16];
    labName.textColor = RGB(51, 51, 51);
    [SupView addSubview:labName];
    
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(imgView.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(0);
        
    }];
    
        UILabel *noName = [[UILabel alloc] init];
        noName.text = @"匿名评价";
        noName.textAlignment = NSTextAlignmentCenter;

        noName.font =  [UIFont fontWithName:Default_APP_Font_Regu size:14];
        noName.textColor = RGB(204, 204, 204);
        [SupView addSubview:noName];
    
    [noName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(labName.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(60);
        make.centerX.mas_equalTo(0);
        
    }];


    UIView *lineLeft = [[UIView alloc] init];
    lineLeft.backgroundColor = RGB(204, 204, 204);
    [SupView addSubview:lineLeft];
    
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(noName.mas_left).mas_offset(-5);
        make.width.mas_equalTo(106);
        make.centerY.mas_equalTo(noName);
        make.height.mas_equalTo(1);

        
    }];

    
    
    UIView *lineRight = [[UIView alloc] init];
    lineRight.backgroundColor = RGB(204, 204, 204);
    [SupView addSubview:lineRight];
    
    
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(noName.mas_right).mas_offset(5);
        make.width.mas_equalTo(106);
        make.centerY.mas_equalTo(noName);
        make.height.mas_equalTo(1);

        
    }];

    UIView *startSupView = [[UIView alloc] init];
    [SupView addSubview:startSupView];
    [startSupView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(noName.mas_bottom).mas_offset(10);
        
        make.width.mas_equalTo(222);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(70);
        
        
    }];

        
    UILabel *fuwuLabel =[[UILabel alloc]init];
    fuwuLabel.font= [UIFont fontWithName:Default_APP_Font_Regu size:14];
    fuwuLabel.textColor = RGB(153, 153, 153);
    fuwuLabel.textAlignment = NSTextAlignmentLeft;
    fuwuLabel.text = @"服务态度";
    [startSupView addSubview:fuwuLabel];
    
    [fuwuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(0);
        
    }];
    
    UILabel *suduLabel =[[UILabel alloc]init];
    suduLabel.font= [UIFont fontWithName:Default_APP_Font_Regu size:14];
    suduLabel.textColor = RGB(153, 153, 153);
    suduLabel.textAlignment = NSTextAlignmentLeft;
    suduLabel.text = @"运输速度";
    [startSupView addSubview:suduLabel];

    [suduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(fuwuLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(60);
        make.leading.mas_equalTo(fuwuLabel);
        
    }];

    // 服务态度的星星
   HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 86, 20)];
    starRatingView.delegate = self;
    starRatingView.spacing = 10;
    starRatingView.maximumValue = 5;//最大星星值
    starRatingView.minimumValue = 0;//最小的星星值
    starRatingView.userInteractionEnabled = YES;
    starRatingView.value = 5;//当前值，默认3
    //   //是否允许半星，默认NO
    starRatingView.allowsHalfStars = NO;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starRatingView.accurateHalfStars = NO;
    starRatingView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starRatingView.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starRatingView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _starRatingView = starRatingView;
    
    
    [startSupView addSubview:starRatingView];
    
    [starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(fuwuLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(fuwuLabel.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(21);
        
    }];

    
    // 服务态度的星星
    HCSStarRatingView *starSuduView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(75, 42, 125, 21)];
    starSuduView.delegate = self;
    starSuduView.maximumValue = 5;//最大星星值
    starSuduView.minimumValue = 0;//最小的星星值
    starSuduView.userInteractionEnabled = YES;
    starSuduView.value = 5;//当前值，默认3
    //   //是否允许半星，默认NO
    starSuduView.allowsHalfStars = NO;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starSuduView.accurateHalfStars = NO;
    starSuduView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starSuduView.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starSuduView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [startSupView addSubview:starSuduView];
    
    [starSuduView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fuwuLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(suduLabel.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(21);
        
    }];
    
 
    CpTextView *cpTextView = [[CpTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    cpTextView.delegate = self;
    cpTextView.returnKeyType = UIReturnKeyDone;
    
    [SupView addSubview:cpTextView];
    cpTextView.backgroundColor = [UIColor whiteColor];
    cpTextView.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cpTextView.myPlaceholder = @"亲，评论一下吧";
    cpTextView.myPlaceholderColor = [UIColor lightGrayColor];
    
    [cpTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(startSupView.mas_bottom).mas_offset(18);
        make.left.mas_equalTo(SupView.mas_left).mas_offset(42);
        make.right.mas_equalTo(SupView.mas_right).mas_offset(-42);
        make.height.mas_equalTo(160);
        
    }];
    [cpTextView rounded:2.0 width:1 color:RGB(204, 204, 204)];


    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sureBtn setTitle:@"提交评论" forState:(UIControlStateNormal)];
    sureBtn.backgroundColor = BGBlue;
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBtn];
    
    
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    
}

- (void)sureBtnClick:(UIButton *)btn{
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    NSString *user = userPhone;
    [manager requsetCommitVaulte:@"app/logisticsevaluate/commitEvaluate" orderId:self.orderID speedScore:_speedScore attitudeScore:_attitudeScore evComment:_evComment appraiser:user];

    
}
- (void)requsetCommitVaulteSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

- (void)requsetCommitVaulteFailed:(NSError *)error{
    
    
}
- (void)starRatingView:(HCSStarRatingView *)view score:(float)score{
    
    int scoreNum = score;
    if (view == self.starRatingView) {
        _attitudeScore = [NSString stringWithFormat:@"%d",scoreNum];
    
    }else{
        
        _speedScore = [NSString stringWithFormat:@"%d",scoreNum];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    _evComment = textView.text;
    [UIView animateWithDuration:0.35 animations:^{
            
            self.SupView.frame = CGRectMake(0, 9, ScreenWidth, ScreenHeight - 64-50);
            
        }];
     [textView resignFirstResponder];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
        [UIView animateWithDuration:0.35 animations:^{
            self.SupView.frame = CGRectMake(0, -150, ScreenWidth, ScreenHeight - 64-50);
        }];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
            [UIView animateWithDuration:0.35 animations:^{
                
                self.SupView.frame = CGRectMake(0, 9, ScreenWidth, ScreenHeight - 64-50);
                
            }];
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
