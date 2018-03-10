//
//  JYCouponDetailViewController.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/3.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "JYCouponDetailViewController.h"
#import "CouponDetailTitleTableViewCell.h"
#import "JYCouponImgTableViewCell.h"
#import "ReceiveCouponsTableViewCell.h"
#import "UseRulesTableViewCell.h"
#import "CouponModel.h"
#import "ReceiveCouponView.h"
@interface JYCouponDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end

static NSString *cellID = @"CouponDetailTitleTableViewCell";
static NSString *cellImgID = @"JYCouponImgTableViewCell";
static NSString *cellReceiveID = @"ReceiveCouponsTableViewCell";
static NSString *cellrulesID = @"UseRulesTableViewCell";


@implementation JYCouponDetailViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"简运";

    [self createTableView];
}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView
{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 20)];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"本活动最终解释权归简运所有";
    bottomLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:12];
    bottomLabel.textColor = RGB(204, 204, 204);
    [footView addSubview:bottomLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = footView;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CouponDetailTitleTableViewCell class] forCellReuseIdentifier: cellID];
    [self.tableView registerClass:[JYCouponImgTableViewCell class] forCellReuseIdentifier: cellImgID];
    [self.tableView registerClass:[ReceiveCouponsTableViewCell class] forCellReuseIdentifier: cellReceiveID];
    [self.tableView registerClass:[UseRulesTableViewCell class] forCellReuseIdentifier: cellrulesID];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
//        self.tableView.estimatedRowHeight =150;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;

    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.row == 2) {
        
        return 110 * HOR_SCALE;
    }else{
        return UITableViewAutomaticDimension;

    }
        
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    
        CouponDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        
         return cell;
    }else if (indexPath.row == 1){

        JYCouponImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellImgID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;

         return cell;
    }else if (indexPath.row == 2){
        
        ReceiveCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReceiveID];
        [cell.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        UseRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellrulesID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model;
        
        return cell;
    }
    
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)receiveBtnClick:(UIButton *)btn{
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/coupon/receiveCoupon"];
    NSString *phone = userPhone;
    [[NetWorkHelper shareInstance] Post:urlstr parameter:@{@"couponId":_model.ID,@"phone":phone} success:^(id responseObj){
        
        NSString *message  =[responseObj objectForKey:@"message"];
        if ([message isEqualToString:@"0"]) {
            
            [self showCouponView];
            [MBProgressHUD showSuccess:@"领取成功"];
            
        }else if ([message isEqualToString:@"410"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [MBProgressHUD showInfoMessage:@"一天只能领取一张优惠券"];

            });
           
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)showCouponView{
    ReceiveCouponView *view = [[ReceiveCouponView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    [view showCouponView];
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
