//
//  JYFavorableViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/29.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYFavorableViewController.h"
#import "HeardImageTableViewCell.h"
#import "ContentTableViewCell.h"
#import "JYCouponDetailViewController.h"
#import "CouponModel.h"
#import <UIImageView+WebCache.h>
@interface JYFavorableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)int num;
@property (nonatomic,strong)NSMutableArray *couponArr;

@end

@implementation JYFavorableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:Default_APP_Font size:20]};
    _num = 2;
    _couponArr = [NSMutableArray array];
    
    self.navigationItem.title = @"活动专区";
    [self createTableView];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    footview.backgroundColor= [UIColor clearColor];
    self.tableView.tableFooterView = footview;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 50;
        self.tableView.estimatedSectionHeaderHeight = 40;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCouponList];
}
- (void)getCouponList{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/coupon/getCouponList"];
    [[NetWorkHelper shareInstance] Post:urlstr parameter:@{@"cpType":@"1"} success:^(id responseObj) {
        
     _couponArr = [CouponModel mj_objectArrayWithKeyValuesArray:responseObj];
    [self.tableView reloadData];
    
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return _couponArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    if (indexPath.row == 0) {
//        if (_num == 2) {
    
            return 233 * HOR_SCALE;

//        }else{
//
//            return 184 * HOR_SCALE;
//
//            }
//
//    }else{
//        return 66;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeardImageTableViewCell *imgCell = [HeardImageTableViewCell cellWithTableView:tableView];
//    ContentTableViewCell *contentCell = [ContentTableViewCell cellWithTableView:tableView];
    imgCell.contentView.backgroundColor = BgColorOfUIView;
//    contentCell.contentView.backgroundColor = BgColorOfUIView;
   
    _num = 1;
    imgCell.bottomHeightConstraint.constant = 49;
    [imgCell layoutIfNeeded];
    CouponModel *model = _couponArr[indexPath.section];
    imgCell.backImg.hidden = YES;
    imgCell.titleLabel.hidden = YES;
    imgCell.lookImg.hidden = YES;
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlStr = [url stringByAppendingString:model.picture];
    [imgCell.heardImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"activity_img_welfare"]];
    imgCell.conentlabel.text = model.title;
    imgCell.getLabel.text = @"";
    imgCell.lookLabel.text = @"";
    
    return imgCell;
            
 
}
//    else if (indexPath.section == 1){
//        _num = 1;
//
//        if (indexPath.row == 0) {
//
//            imgCell.backImg.hidden = NO;
//            imgCell.heardImageView.image = [UIImage imageNamed:@"activity_img_new"];
//            imgCell.titleLabel.text = @"新用户下单立减，你还在犹豫什么";
//            imgCell.bottomView.hidden = YES;
//            return imgCell;
//
//        }else{
//
//            contentCell.imgView.image = [UIImage imageNamed:@"alipay"];
//            contentCell.contentLabel.text = @"推荐好友使用简运，领取大红包！";
//            return contentCell;
//
//        }

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"2017年10月29日 17:30";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = RGB(102, 102, 102);
    lab.font = [UIFont fontWithName:Default_APP_Font_Regu size:11];
    return lab;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JYCouponDetailViewController *vc = [[JYCouponDetailViewController alloc] init];
    vc.model = _couponArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
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
