//
//  JYPayCouponViewController.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/8.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "JYPayCouponViewController.h"
#import "CouponLeftTableView.h"
#import "MineCouponModel.h"
@interface JYPayCouponViewController ()
@property (nonatomic,strong)NSArray *mineCounponArr;
@property (nonatomic,strong)CouponLeftTableView *tableview;
@end

@implementation JYPayCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;

    self.navigationItem.title = @"可用优惠券";
   
    [self creatTableView];
    [self getCouponList];
}
- (void)creatTableView{
    self.tableview = [[CouponLeftTableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth,  ScreenHeight - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableview.leftRight = @"JYPayCouponViewController";
    [self.view addSubview:self.tableview];

    __weak __typeof(self) weakSelf = self;
    
    self.tableview.BlockMineCoupon = ^(MineCouponModel *model) {
        if (weakSelf.BlockMineCouponVaule) {
            weakSelf.BlockMineCouponVaule(model);
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (void)getCouponList{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/coupon/getMyCouponList"];
    NSString *phone = userPhone;
    [[NetWorkHelper shareInstance] Post:urlstr parameter:@{@"phone":phone,@"status":@"0"} success:^(id responseObj) {
        
        NSMutableArray *dataArr = [MineCouponModel mj_objectArrayWithKeyValuesArray:responseObj];
        self.tableview.dataArr = dataArr;
        
        [self.tableview reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
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
