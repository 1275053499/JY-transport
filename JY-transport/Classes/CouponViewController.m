//
//  CouponViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponLeftTableView.h"
#import "MineCouponModel.h"
typedef enum {
    
    CouponStatusAvailable = 0, //0 可用
    CouponStatusUnavailable   //失效
    
}CouponStatus;
@interface CouponViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *usedBtn;
@property (nonatomic,strong)UIButton *noUsedBtn;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)CouponLeftTableView *leftTableView;
@property (nonatomic,strong)CouponLeftTableView *rightTableView;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSMutableArray *mineCounponArr;
@property (nonatomic,strong)void(^BlockMineCoupon)(NSString *vaule); 


@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"优惠券";
    _status = @"0";
    _mineCounponArr = [NSMutableArray array];
    [self creatTopView];
    [self createTableView];
    
    [self getCouponList:CouponStatusAvailable];

}


- (void)getCouponList:(CouponStatus)statu{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/coupon/getMyCouponList"];
    NSString *phone = userPhone;
    NSString *status = [NSString stringWithFormat:@"%d",statu];
    _status = status;
    [[NetWorkHelper shareInstance] Post:urlstr parameter:@{@"phone":phone,@"status":status} success:^(id responseObj) {
        
        _mineCounponArr = [MineCouponModel mj_objectArrayWithKeyValuesArray:responseObj];
        if ([_status isEqualToString:@"0"]) {
            
            _leftTableView.dataArr = _mineCounponArr;
            [self.leftTableView reloadData];
            
        }else if ([_status isEqualToString:@"1"]){
            
            _rightTableView.dataArr = _mineCounponArr;
            [self.rightTableView reloadData];
            
        }

    } failure:^(NSError *error) {
        
    }];
}

-(void)createTableView
{
    self.leftTableView = [[CouponLeftTableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth,  ScreenHeight - NavigationBarHeight - StateBarHeight - 40) style:UITableViewStylePlain];
    self.leftTableView.leftRight = @"left";
    
    [self.scrollView addSubview:self.leftTableView];
    self.rightTableView = [[CouponLeftTableView alloc]initWithFrame:CGRectMake(ScreenWidth,0, ScreenWidth,  ScreenHeight - NavigationBarHeight - StateBarHeight - 40) style:UITableViewStylePlain];
    self.rightTableView.leftRight = @"right";
   
    [self.scrollView addSubview:self.rightTableView];
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)creatTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2/2 - 44/2, 40 -1, 44, 1)];
    _lineView.backgroundColor = BGBlue;
    [topView addSubview:_lineView];
    [self.view addSubview:topView];
    
    UIButton *usedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [usedBtn setTitle:@"可用" forState:(UIControlStateNormal)];
    [usedBtn setTitleColor:RGB(153, 153, 153) forState:(UIControlStateNormal)];
    [usedBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    usedBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    usedBtn.frame = CGRectMake(0, 0, ScreenWidth/2 , 40);
    usedBtn.selected = YES;
    usedBtn.tag = 3018;
    _usedBtn = usedBtn;
    [usedBtn addTarget:self action:@selector(usedBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:usedBtn];
    
    UIButton *noUsedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [noUsedBtn setTitle:@"失效" forState:(UIControlStateNormal)];
    [noUsedBtn setTitleColor:RGB(153, 153, 153) forState:(UIControlStateNormal)];
    [noUsedBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    noUsedBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    noUsedBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 , 40);
    [topView addSubview:noUsedBtn];
    _noUsedBtn = noUsedBtn;
    [noUsedBtn addTarget:self action:@selector(usedBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    noUsedBtn.tag = 3019;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 40)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate =self;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth *2,0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.scrollView];
}

- (void)usedBtnClick:(UIButton *)Btn{
    
    if (Btn.tag == 3018) {

        [self getCouponList:CouponStatusAvailable];
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        _lineView.frame = CGRectMake(ScreenWidth/2/2 - 44/2, 40 -1, 44, 1);
        _usedBtn.selected = YES;
        _noUsedBtn.selected = NO;
       
        
    }else if(Btn.tag == 3019){
        
        [self getCouponList:CouponStatusUnavailable];
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth,0) animated:YES];
        _lineView.frame = CGRectMake((ScreenWidth - ScreenWidth/2/2 - 44/2), 40 -1, 44, 1);
        _noUsedBtn.selected = YES;
        _usedBtn.selected = NO;
        
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewX =  scrollView.contentOffset.x;
    NSLog(@"%f-----",scrollviewX);
    int a = round(scrollviewX/ScreenWidth);
    CGFloat lineleftX = ScreenWidth/2/2 - 44/2;
    CGFloat lineRightX = ScreenWidth - ScreenWidth/2/2 - 44/2;

    if (a == 0) {
        _usedBtn.selected = YES;
        _noUsedBtn.selected = NO;
        
    }else{
        _usedBtn.selected = NO;
        _noUsedBtn.selected = YES;
    }
    
    if (scrollviewX >=  lineleftX && scrollviewX <= lineRightX ){
        
        _lineView.frame = CGRectMake(scrollviewX, 40 -1, 44, 1);
        
    }else{
        
        if (a == 0) {
            
            _lineView.frame = CGRectMake(ScreenWidth/2/2 - 44/2, 40 -1, 44, 1);
            
        }else{
            
            _lineView.frame = CGRectMake((ScreenWidth - ScreenWidth/2/2 - 44/2), 40 -1, 44, 1);
            
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

        [self weSetScrollViewContentOffset:scrollView];


}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    if(!decelerate){
//
//        [self weSetScrollViewContentOffset:scrollView];
//
//    }
//}

- (void)weSetScrollViewContentOffset:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x <= ScreenWidth / 2 && scrollView.contentOffset.x > 0) {
        
        CGPoint point = scrollView.contentOffset;
        point.x = 0;
        [self.scrollView setContentOffset:point animated:YES];
        [self getCouponList:CouponStatusAvailable];

    }else if (scrollView.contentOffset.x > ScreenWidth / 2 && scrollView.contentOffset.x <= ScreenWidth){
        
        CGPoint point = scrollView.contentOffset;
        point.x = ScreenWidth;
        [self.scrollView setContentOffset:point animated:YES];
        [self getCouponList:CouponStatusUnavailable];

    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
