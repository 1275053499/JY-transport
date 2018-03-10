//
//  evaluateViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "evaluateViewController.h"
#import "CpTextView.h"
//#import "WSStarRatingView.h"

#import "HCSStarRatingView.h"
@interface evaluateViewController ()<HCSStarRatingViewDelegate>
@property(nonatomic,weak)HCSStarRatingView *starSuduView;
@property(nonatomic,weak)CpTextView *cpTextView ;
@end

@implementation evaluateViewController{
    UILabel *scoreLabel;
    float FuWuscore;
    UILabel *suduScoreLabel;
    float suduScore;
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"评论";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
   
      UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"提交" target:self action:@selector(beginSureScore)];
   
    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    FuWuscore = 5;
    suduScore = 5;

    self.view.backgroundColor = BgColorOfUIView;
    
    [self creatContentView];
    [self creatFootView];
    //获取司机信息
    [self getDriverDetail];
    
    
    
    
}

-(void)getDriverDetail
{
//    
//    [[NetWorkHelper shareInstance]Post:commentAndGiveScoreURL parameter:@{@"evaluate":str} success:^(id responseObj) {
//        
//        NSError *error;
//        
//        
//        if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
//            
//            [MBProgressHUD showSuccess:@"评论成功"];
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//        }else{
//            
//            [MBProgressHUD showError:@"评论失败，请检查网路"];
//        }
//        
    
        
        
        
        
//        
//        
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络异常" toView:self.view];
//    }];
//    
    
}




// 开始提交评论和评分
-(void)beginSureScore
{
    if ([self.cpTextView.text isEqualToString:@""]) {
        
        [MBProgressHUD showSuccess:@"评论不能为空"];
        
    }else{
        
        
        NSString *newFuWuScoreLabe = [NSString stringWithFormat:@"%.1f",FuWuscore];
        NSString *newSuduScoreLabe = [NSString stringWithFormat:@"%.1f",suduScore];
        NSDictionary *dic =@{@"orderNo":self.model.orderNo,@"evObject":self.model.serviceStaff,@"evGrade":newFuWuScoreLabe,@"evPotin":newSuduScoreLabe,@"evComment":self.cpTextView.text,@"createBy":userPhone};
 
        NSString *str = [self dictionaryToJson:dic];
        NSLog(@"======%@",dic);
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"app/evaluate/commit"];

        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"evaluate":str} success:^(id responseObj) {
            
            if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
                
                [MBProgressHUD showSuccess:@"评论成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];

                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"evaluateSuccess" object:nil];
                
                
            }else{
            
                [MBProgressHUD showError:@"评论失败，请检查网路"];
            }
            
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];
        }];
        
        
        
    
    }

}
//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark - action handle
- (void)returnAction
{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"OrderMoneyDidGive" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 创建View
-(void)creatContentView
{
    CpTextView *cpTextView = [[CpTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    [self.view addSubview:cpTextView];
    self.cpTextView = cpTextView;
    cpTextView.backgroundColor = [UIColor whiteColor];
    cpTextView.font = [UIFont fontWithName:Default_APP_Font size:15];
//    cpTextView.myPlaceholder = @"好评";
    cpTextView.text = @"好评";
    cpTextView.myPlaceholderColor = [UIColor lightGrayColor];


}

-(void)creatFootView
{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, ScreenWidth, ScreenHeight - 160)];
    footView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footView];
    
    UIButton *driverButton = [[UIButton alloc]init];
    [footView addSubview:driverButton];
    [driverButton setImage:[UIImage imageNamed:@"grade"] forState:UIControlStateNormal];
    [driverButton setTitle:@"  司机评分" forState:UIControlStateNormal];
    driverButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
    [driverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [driverButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(footView.mas_left).mas_offset(12);
    make.top.mas_equalTo(footView.mas_top).mas_offset(12);
    
    }];
    
    FMButton *collectButton = [FMButton createFMButton];
    collectButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
//    [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateSelected];
    [footView addSubview:collectButton];
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(driverButton.mas_centerY).mas_offset(0);
        make.right.mas_equalTo(footView.mas_right).mas_offset(-12);
        
    }];
    
    collectButton.block = ^(FMButton *button){
    
        button.selected = !button.selected;
        if (button.selected) {
        
            
            
        }else{
        
        
        
        
        }
       
    };
    
    
    UILabel *collectLabel = [[UILabel alloc]init];
    collectLabel.text = @"收藏";
    collectLabel.font = [UIFont fontWithName:Default_APP_Font size:13];
    collectLabel.textColor = Default_label_colol;
    
    [footView addSubview:collectLabel];
    [collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(collectButton.mas_centerY).mas_offset(0);
        make.right.mas_equalTo(collectButton.mas_left).mas_offset(-10);
        
    }];
    
    
    
    
    
    
    UILabel *fuwuLabel =[[UILabel alloc]init];
    fuwuLabel.font= [UIFont fontWithName:Default_APP_Font size:12];
    fuwuLabel.textColor = [UIColor blackColor];
    fuwuLabel.textAlignment = NSTextAlignmentLeft;
    fuwuLabel.text = @"服务态度";
    [footView addSubview:fuwuLabel];
    
    [fuwuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(driverButton.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(footView.mas_left).mas_offset(12);
        
    }];
    
    
    
    UILabel *suduLabel =[[UILabel alloc]init];
    suduLabel.font= [UIFont fontWithName:Default_APP_Font size:12];
    suduLabel.textColor = [UIColor blackColor];
    suduLabel.textAlignment = NSTextAlignmentLeft;
    suduLabel.text = @"运输速度";
    [footView addSubview:suduLabel];
    [suduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fuwuLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(footView.mas_left).mas_offset(12);
        
    }];
    
    // 服务态度的星星
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 86, 20)];
    starRatingView.delegate = self;
    starRatingView.maximumValue = 5;//最大星星值
    starRatingView.minimumValue = 0;//最小的星星值
    starRatingView.userInteractionEnabled = YES;
    starRatingView.value = 5;//当前值，默认5
    //   //是否允许半星，默认NO
    starRatingView.allowsHalfStars = NO;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starRatingView.accurateHalfStars = NO;
    starRatingView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starRatingView.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starRatingView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];


    
  
    [footView addSubview:starRatingView];
    [starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fuwuLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(fuwuLabel.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(21);
        
    }];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, self.view.frame.size.width-60, 25)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor lightGrayColor];
    scoreLabel.font =  [UIFont systemFontOfSize:20];
    [footView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(starRatingView.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(starRatingView.mas_centerY);
        
    }];
    
    scoreLabel.text = @"5.0分";
    
    // 服务态度的星星
    HCSStarRatingView *starSuduView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(75, 42, 125, 21)];
    starSuduView.delegate = self;
    starSuduView.maximumValue = 5;//最大星星值
    starSuduView.minimumValue = 0;//最小的星星值
    starSuduView.userInteractionEnabled = YES;
    starSuduView.value = 5;//当前值，默认5
    //   //是否允许半星，默认NO
    starSuduView.allowsHalfStars = NO;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starSuduView.accurateHalfStars = NO;
    starSuduView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starSuduView.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starSuduView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [footView addSubview:starSuduView];
    [starSuduView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fuwuLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(suduLabel.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(21);
        
    }];
    self.starSuduView = starSuduView;
    
    suduScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, self.view.frame.size.width-60, 25)];
    suduScoreLabel.textAlignment = NSTextAlignmentCenter;
    suduScoreLabel.textColor = [UIColor lightGrayColor];
    suduScoreLabel.font =  [UIFont systemFontOfSize:20];
    [footView addSubview:suduScoreLabel];
    [suduScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(starRatingView.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(starSuduView.mas_centerY);
        
    }];

        suduScoreLabel.text = @"5.0分";


}
- (void)starRatingView:(HCSStarRatingView *)view score:(float)score{
    int scr = (int)score;
    if (view == self.starSuduView ) {
      
        suduScoreLabel.text = [NSString stringWithFormat:@"%d.0分",scr];
        FuWuscore = score;
        
    }else{
        
        scoreLabel.text = [NSString stringWithFormat:@"%d.0分",scr];
        suduScore = score;
    }

    
}
@end
