
//
//  JYOrderDetailViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYOrderDetailViewController.h"
#import "JYOrderDetailCell.h"
#import "JYGrabTableViewCellSecond.h"
#import "JYGrabTableViewCellThird.h"
#import "JYGrabServiceTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYORderNumberTableViewCell.h"
#import "JYLookPhotoViewController.h"
#import "JYHomeRequestDate.h"
#import "JYOrderDetailModel.h"
#import "JYConfirmPriceViewController.h"
#import "JYShipBaseViewController.h"
#import "JYWriteEvaluationViewController.h"
#import "JYGrabValueTableViewCell.h"
#import "JYLookLogisticsViewController.h"
@interface JYOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JYHomeRequestDateDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)FMButton *cancelButton;
@property (nonatomic,strong)FMButton *sureButton;
@property (nonatomic,strong)JYOrderDetailModel *detailModel;
@property (nonatomic,strong)UIButton *sureBtn;

@end

@implementation JYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
     self.navigationItem.title = @"订单详情";
      self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self creatTableView];
    [self creatFootView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    

}
- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth ,ScreenHeight - NavigationBarHeight - StateBarHeight - 51) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = YES;
    self.tableView.estimatedRowHeight = 100.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
}

//前台
- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 50);
     self.footView.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight, ScreenWidth, 50);
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getDetailOrderInfo];

}
//获得订单详情
- (void)getDetailOrderInfo{
    
    JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    [manager requsetInquiryQuotation:@"app/logisticsorder/getDetailOrder" orderID:self.orderID];
    
}
- (void)requsetInquiryQuotationSuccess:(NSDictionary *)resultDic{
    
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
        JYOrderDetailModel *model = [JYOrderDetailModel mj_objectWithKeyValues:resultDic];
        if ([model.orderStatus isEqualToString:@"9"]) {
            _sureBtn.hidden = YES;

        }
        _detailModel = model;
        [self.tableView reloadData];
        
    }
}

- (void)requsetInquiryQuotationFailed:(NSError *)error{
    
    
}
- (void)returnAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)creatFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight, ScreenWidth, 50)];
    self.footView =footView;
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0,135,50);
    [sureBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sureBtn];
    _sureBtn = sureBtn;
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake(135, 0,(ScreenWidth - 135), 50);
    [yueBtn setTitle:@"去支付" forState:UIControlStateNormal];
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [yueBtn setBackgroundColor:BGBlue];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView  addSubview:yueBtn];
    
    
    if ([self.orderStatus isEqualToString:@"6"]) {
        [sureBtn setTitle:@"重新下单" forState:UIControlStateNormal];
         sureBtn.frame = CGRectMake(0, 0,ScreenWidth,50);

        yueBtn.hidden = YES;
        self.footView.hidden = NO;

    }else if ([self.orderStatus isEqualToString:@"5"]) {
        sureBtn.hidden = NO;
        [sureBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        sureBtn.frame = CGRectMake(0, 0,ScreenWidth,50);
        
        yueBtn.hidden = YES;
        self.footView.hidden = NO;

    }else if ([self.orderStatus isEqualToString:@"9"] || [_orderStatus isEqualToString:@"20"]) {
        sureBtn.hidden = YES;
        yueBtn.hidden = YES;
        self.footView.hidden = YES;

    }
}

//重新下单按钮
- (void)cancelBtnClick:(UIButton *)button{
    
    if ([self.orderStatus isEqualToString:@"6"]) {
        
        JYShipBaseViewController *delverGoodsVC = [[JYShipBaseViewController alloc]init];
        delverGoodsVC.detailModel = _detailModel;
        delverGoodsVC.whichType = @"specialLine";
        [self.navigationController pushViewController:delverGoodsVC animated:YES];
        
        
    }else if ([self.orderStatus isEqualToString:@"5"]) {
        
        JYWriteEvaluationViewController *vc = [[JYWriteEvaluationViewController alloc] init];
        vc.orderID = _detailModel.id;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
   
}
- (void)sureBtnClick:(UIButton *)btn{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    

        if (section == 1 || section == 3) {
            if ([_orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
                
                return 0;

            }else{
                return 9;
            }
        }else if (section == 2){
            
            if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
                
                return 0;
            }else{
                return 9;
            }
            
        }else{
            return 9;
        }
    
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if ([self.orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
                return 44;
            }else{
                return 137;

            }
        }else if (indexPath.row == 1){
            
            return UITableViewAutomaticDimension;
            
        }else if (indexPath.row == 2){
            return 40;
        }else {
            return UITableViewAutomaticDimension;

        }
    }else if (indexPath.section == 1 || indexPath.section == 3){
        if ([self.orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
        
            return 0;
        }else{
            
            return 44;
        }
        
    }else if (indexPath.section == 2){
        
        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
            return 0;
        }else{
            
            return 44;
            
        }
    }else{
        return 83;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            JYGrabTableViewCellSecond *cell = [JYGrabTableViewCellSecond cellWithTableView:tableView];
            if ([self.orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
                cell.hidden = YES;
                
                
                JYGrabValueTableViewCell *cellTime = [JYGrabValueTableViewCell cellWithTableView:tableView];
                cellTime.selectionStyle = UITableViewCellSelectionStyleNone;

                return cellTime;

            }
            cell.graylineView.hidden = YES;
            cell.model = _detailModel;
            
            return cell;
        }else if (indexPath.row == 1){
            JYOrderDetailCell *cell  = [JYOrderDetailCell cellWithTableView:tableView];
            cell.model = _detailModel;

            return cell;
        }else if (indexPath.row == 2){
            
            JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
            cell.nameConstraintLeading.constant = 48;
            [tableView layoutIfNeeded];
            [cell setvalueforCellRowTwo:_detailModel.jyCargoDetails];
            return cell;
        }else if (indexPath.row == 3){
            
            JYGrabTableViewCellThird *cell = [JYGrabTableViewCellThird cellWithTableView:tableView];
            cell.nameConstraintLeading.constant = 48;
            [tableView layoutIfNeeded];
            [cell setvalueforCellRowThree:_detailModel.jyCargoDetails isInsure:_detailModel.isInsure];

            
            return cell;
        }else{
            
            JYGrabServiceTableViewCell *cell = [JYGrabServiceTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell layoutServiceView:_detailModel.serviceDetails];
            return cell;

        }
      

    }else if (indexPath.section == 1){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
        if ([self.orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
            cell.hidden = YES;
        }
        cell.size = CGSizeMake(ScreenWidth -14, 44);
        [cell rounded:2.0];
        cell.naemLabel.text = @"查看货物描述";
        return cell;
        
    }else if (indexPath.section == 2){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
        cell.size = CGSizeMake(ScreenWidth -14, 44);
        [cell rounded:2.0];
        cell.naemLabel.text = @"查看物流";
        
        if (_detailModel.transportNumber == nil || [_detailModel.transportNumber isEqual:[NSNull null]] || _detailModel.transportNumber.length <= 0) {
            
            cell.hidden = YES;
        }else{
            
            cell.hidden = NO;
            
        }
        
        return cell;

    }else if (indexPath.section == 3){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
        if ([self.orderStatus isEqualToString:@"6"] || [_orderStatus isEqualToString:@"20"]) {
            cell.hidden = YES;
        }
        cell.size = CGSizeMake(ScreenWidth -14, 44);
        [cell rounded:2.0];
        cell.naemLabel.text = @"查看物流公司信息";
        return cell;
        
    }else{
        
        JYORderNumberTableViewCell  *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYORderNumberTableViewCell class]) owner:nil options:0][0];
        cell.size = CGSizeMake(ScreenWidth -14, 83);
        [cell rounded:2.0];
        cell.model = _detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;

}

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        JYLookPhotoViewController *vc = [[JYLookPhotoViewController alloc] init];
        
        vc.describePhoto = _detailModel.describePhoto;
        vc.describeContent = _detailModel.describeContent;

        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2) {
        JYLookLogisticsViewController *vc = [[JYLookLogisticsViewController alloc] init];
        vc.transportNumber = _detailModel.transportNumber;
        vc.orderDetailModel = _detailModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        
        JYConfirmPriceViewController *vc =[[JYConfirmPriceViewController alloc] init];
        JYServiceProviderModel *model = _detailModel.jyServiceProvider;
        vc.logisticsId = model.logisticsId;
        vc.fromWhichVC =  @"JYOrderDetailViewController";
        [self.navigationController pushViewController:vc animated:YES];

        
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
        contenView.backgroundColor = BgColorOfUIView;
    
        return contenView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    
    return contenView;
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
