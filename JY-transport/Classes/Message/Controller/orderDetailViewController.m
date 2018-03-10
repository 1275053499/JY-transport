//
//  orderDetailViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "orderDetailViewController.h"
#import "OrderMessageCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderThreeCell.h"
#import "OrderDetailFourCell.h"
#import "OrderDetailCell.h"
#import "OrderDetailSixCell.h"
#import "lookForDriverMapController.h"
#import "payViewController.h"
#import "LookForCarViewController.h"
#import "cancelAlertView.h"
#import "DriverInfoMode.h"
#import "XGAnnotation.h"
#import "LookEvaluateViewController.h"
#import "MessageRequsetData.h"
#import "MessageRequestDelegate.h"
#import "OrderHeardTableViewCell.h"
#import "CarTypeTableViewCell.h"
#import "JYLookPhotoTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "TimeOutFeeView.h"
@interface orderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MessageRequestDelegate,cancelAlertViewDelegate>

@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property(nonatomic,strong)FMButton *payButton;
@property(nonatomic,strong)FMButton *cancelButton;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,weak)UIView *footView ;
@property(nonatomic,strong)OrderModel *model;
@property(nonatomic,strong)cancelAlertView *alert;
@property(nonatomic,strong)NSTimer *timerorder;




@end

@implementation orderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BgColorOfUIView;
    [self getOrderDetail];//获得订单详情
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.arrivePlaceAddressArray = [NSMutableArray array];
     NSArray *arr= [self.OrderModel.arrivePlace componentsSeparatedByString:@","];
    [self.arrivePlaceAddressArray addObjectsFromArray:arr];
    [self.arrivePlaceAddressArray removeLastObject];
    self.arr = @[@"时间临时有变",@"价钱没谈好",@"信息填写错误，要重新下订单",@"其他原因"];

    self.navigationItem.title = @"订单详情";
    self.statusFrames = [NSMutableArray array];
    
    [self creatTableView];
   
    [self creatFootView];
    
   // }
    
  
    //创建footView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderEndSucces) name:@"orderEndSuccess" object:nil];//订单结束成功
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetail) name:@"orderbeginWorking" object:nil];//订单开始成功服务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetail) name:@"getDrivers" object:nil];//司机抢单  需要刷新订单状态
//    [self addTimerQueryData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];

    
}


- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 50);
    
    self.footView.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight, ScreenWidth, 50);
}


//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    [self performSelector:@selector(addTimerQueryData) withObject:nil afterDelay:0.5];
    [self getOrderDetail];
}
//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self.timerorder invalidate];
    _timerorder = nil;
}
//每3秒刷新订单 查询订单状态
- (void)addTimerQueryData{
    
    _timerorder = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(getOrderDetail) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerorder forMode:NSRunLoopCommonModes];


}
-(void)getOrderDetail
{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getReqDetailByOrderNo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo": self.OrderModel.orderNo,@"phone":userPhone} success:^(id responseObj) {
        OrderModel *model = [OrderModel mj_objectWithKeyValues:responseObj];
        NSLog(@"%@",responseObj);
      self.model = model;
      [self.tableView reloadData];
        
        if ([self.model.basicStatus isEqualToString:@"4"] ||  [self.model.basicStatus isEqualToString:@"9"] ) {
            
            
        self.tableView .frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight );
            
        }else if ([self.model.basicStatus isEqualToString:@"3"]){
        
            self.payButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.footView.hidden = NO;
            [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
            self.payButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
            
        }else if ([self.model.basicStatus isEqualToString:@"5"]){
        
            self.payButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.footView.hidden = NO;
            [self.payButton setTitle:@"重新下单" forState:UIControlStateNormal];
            self.payButton.frame = CGRectMake(0, 0, ScreenWidth, 50);

        
        }else if ( [self.model.basicStatus isEqualToString:@"6"]){
            
            self.payButton.hidden = NO;
            self.cancelButton.hidden = NO;
            self.footView.hidden = NO;
            
            self.cancelButton.frame = CGRectMake(0, 0,135, 50);
            self.payButton.frame = CGRectMake(135, 0 , ScreenWidth - 135, 50);
            [self.payButton setTitle:@"去确认" forState:UIControlStateNormal];
            [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        }else if ([self.model.basicStatus isEqualToString:@"0"]){
            
            self.payButton.hidden = NO;
            self.cancelButton.hidden = NO;
            self.footView.hidden = NO;
            self.cancelButton.frame = CGRectMake(0, 0,135, 50);
            self.payButton.frame = CGRectMake(135,0, ScreenWidth - 135, 50);
            [self.payButton setTitle:@"进入地图" forState:UIControlStateNormal];
            [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            
        }else if ([self.model.basicStatus isEqualToString:@"1"]){
            
            self.payButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.footView.hidden = NO;
            
//            self.cancelButton.frame = CGRectMake(0, 0,ScreenWidth , 50);
            self.payButton.frame = CGRectMake(0,0, ScreenWidth, 50);

            [self.payButton setTitle:@"进入地图" forState:UIControlStateNormal];
            //[self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            
        }else if ([self.model.basicStatus isEqualToString:@"2"]){
            
            self.payButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.footView.hidden = NO;
            self.payButton.frame = CGRectMake(0, 0,ScreenWidth , 50);

            [self.payButton setTitle:@"进入地图" forState:UIControlStateNormal];
            
        }else if ([self.model.basicStatus isEqualToString:@"7"] || [self.model.basicStatus isEqualToString:@"8"]){
            
            self.footView.hidden = NO;
            self.payButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.payButton.frame = CGRectMake(0, 0, ScreenWidth, 50);
            [self.payButton  setTitle:@"进入地图" forState:UIControlStateNormal];
            
        }else{
            
 
        }
        
        

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];





}




//结束服务成功
-(void)orderEndSucces
{

    [self getOrderDetail];
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight );

}


//收到订单成功取消的通知 退出
#pragma mark - action handle
- (void)returnAction
{
    

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatFootView
{
    
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight, ScreenWidth, 50)];
        self.footView =footView;
        footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footView];
    

        FMButton *payButton = [FMButton createFMButton];
        payButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payButton setBackgroundColor:BGBlue];
        [footView addSubview:payButton];
        
        
        FMButton *cancelButton = [FMButton createFMButton];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
        [cancelButton setBackgroundColor:RGB(105, 181, 240)];
        cancelButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        [footView addSubview:cancelButton];
         self.cancelButton =cancelButton;
        
        self.payButton = payButton;
        self.footView.hidden = YES;
        self.payButton.hidden = YES;
        self.cancelButton.hidden = YES;
    
     [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        payButton.block = ^(FMButton *button){
            
            if ([self.model.basicStatus isEqualToString:@"0"] || [self.model.basicStatus isEqualToString:@"1"] || [self.model.basicStatus isEqualToString:@"2"] || [self.model.basicStatus isEqualToString:@"7"] || [self.model.basicStatus isEqualToString:@"8"]) {
                
                lookForDriverMapController *OrederMapVC = [[lookForDriverMapController alloc]init];
                OrederMapVC.orderNunber = self.model.orderNo;
                OrederMapVC.model =self.model;

                [self.navigationController pushViewController:OrederMapVC animated:YES];
            }            else if ([self.model.basicStatus isEqualToString:@"3"]){
                //去支付
                payViewController *payVC = [[payViewController alloc]init];
                payVC.model = self.model;
                [self.navigationController pushViewController:payVC animated:YES];
                
            
            }else if ([self.model.basicStatus isEqualToString:@"5"]){
            // 重新下单
                LookForCarViewController *vc = [[LookForCarViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            
            
            }else if ([self.model.basicStatus isEqualToString:@"6"]){
                // 进入地图
                
                lookForDriverMapController *OrederMapVC = [[lookForDriverMapController alloc]init];
                OrederMapVC.orderNunber = self.model.orderNo;
                DriverInfoMode  *drModel =  self.model.jyTruckergroup;
                OrederMapVC.drModel = drModel;
                OrederMapVC.model = self.model;
                OrederMapVC.isAddSureAlertViewStr = @"sureAlertView";
                [self.navigationController pushViewController:OrederMapVC animated:YES];
                
                
            }

    };
    
  }
- (void)PayMethodSelectionViewControllerBackWithpayName:(NSString *)payname{
   // self.payWayLabel.text = payname;
    NSLog(@"%@",payname);
}
-(void)btnClick:(UIButton *)button
{
   
    _alert = [cancelAlertView GlodeBottomView];
    _alert.titleArray = self.arr;
    _alert.delegate = self;
    [_alert show];
    
}
- (void)cancelReasonButtonClick:(NSInteger)index content:(NSString *)str{
    
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/cancelOrderToUser"];
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"cancelType":str,@"orderNo":self.model.orderNo,@"remark":@""} success:^(id responseObj) {
        NSString *message = [responseObj objectForKey:@"message"];
        
        if ([message isEqualToString:@"0"]) {
            
            [_alert dissMIssView];
            [self returnAction];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderCancelSuccess" object:nil];
                        
        }
        
    } failure:^(NSError *error) {
        
    }];

}
//创建UItableView
-(void)creatTableView
{
    
    if ([self.model.basicStatus isEqualToString:@"3"] || [self.model.basicStatus isEqualToString:@"4"] || [self.model.basicStatus isEqualToString:@"5"]){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
        
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight - NavigationBarHeight - StateBarHeight -50) style:UITableViewStylePlain];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 108;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BgColorOfUIView;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
  
 
}

#pragma mark - UITableData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    }else if (section == 1) {
        
        if ([self.model.isLieu isEqualToString:@"1"]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == 2) {
        
        return 1;
        
    }else if (section == 3){
        
       return self.arrivePlaceAddressArray.count+1;;
    
    }else if (section == 5 ){
        
        if (self.model.service.length > 0) {
            
            return 2;
            
        }else{
            
            return 0;
        }
    
    }else if (section == 6 ){
        
        return 2;
        
    }else if (section == 7){
        
        if ([self.model.basicStatus isEqualToString:@"0"]) {
            
            return 0;
            
        }else{
            
            return 2;
        }

    
    }else if (section == 8){
        if (self.model.enclosure == nil || [self.model.enclosure isEqual:[NSNull null]] || self.model.enclosure.length <= 0 ) {
            
            return 0;
        }else{
            return 2;
        }
    }else if (section == 9){
        
        return 4;
    }else{
        
        return 1;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 10;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ID111"];
    if (cell==nil) {
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID111"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
    
    OrderModel *model = self.model;
    if (indexPath.section == 0) {
        
        OrderThreeCell *cell = [OrderThreeCell cellWithOrderTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.money.text = [@"¥" stringByAppendingString:[NSString stringWithFormat:@"%.0f",self.model.bid]];
        
        cell.infoLabel.attributedText = [self infoLabelAttibutedString];
          [cell.moneydetailButton addTarget:self action:@selector(moneydetailButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (model.timeType == 1) {
            
            cell.timeLabel.text = @"即时用车";
        }else{
            
            [cell setDateFromString:model.departTime];
            
        }
      
        return cell;

    }else if (indexPath.section == 1){
        
        NoticeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoticeTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.switchBtn.hidden = YES;
        cell.nameLabel.text = @"代收货款";
        cell.nameLabel.textColor = RGB(51, 51, 51);
        cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        cell.detailLab.textColor = RGB(255, 75, 45);
        cell.detailLab.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
        if (self.model.lieuAmount == nil && [self.model.lieuAmount isEqual:[NSNull null]]) {
            
            
        }else{
            NSString *money = [NSString stringWithFormat:@"¥%@",self.model.lieuAmount];
            cell.detailLab.text = money;
        }
       
        
        return cell;
    }else if (indexPath.section == 2){
        
        
        OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectionBtn.hidden = YES;
        cell.heardName.text = @"地址信息";
        return cell;
        
    }else if (indexPath.section == 3){
        
        OrderMessageCell *cell = [OrderMessageCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
            cell.place.text = model.departPlace;
            
        }else if (indexPath.row == self.arrivePlaceAddressArray.count){
            
            cell.place.text = self.arrivePlaceAddressArray[indexPath.row-1];
            cell.iconImage.image = [UIImage imageNamed:@"destination-1"];
            
        }else{
            
            cell.iconImage.image = [UIImage imageNamed:@"pass"];
            cell.place.text = self.arrivePlaceAddressArray[indexPath.row-1];
        }
        
        return cell;

    
    }else if (indexPath.section == 4){
        
        CarTypeTableViewCell *cell = [CarTypeTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.model = self.model;
        return cell;
    
    
    }else if (indexPath.section == 5){
        
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.collectionBtn.hidden = YES;
            cell.heardName.text = @"服务信息";
            return cell;
            
        }else{
           
            OrderDetailFourCell *cell = [OrderDetailFourCell cellWithOrderTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell layoutServiceView:model];
            
            return cell;
            
        }
 
    }else if (indexPath.section == 6){
    
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.collectionBtn.hidden = YES;
            cell.heardName.text = @"联系人信息";
            return cell;
        }else{

            OrderDetailSixCell *cell = [OrderDetailSixCell cellWithOrderTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.model;
            return cell;
        
        }
    }else if (indexPath.section == 7){
    
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.heardName.text = @"司机信息";
            cell.model = self.model;
            
            return cell;
        }else{
            
            OrderDetailCell *cell = [OrderDetailCell cellWithOrderTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.EvaluationBtn addTarget:self action:@selector(evaluationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.callDriverBtn addTarget:self action:@selector(callDriverPhone:) forControlEvents:(UIControlEventTouchUpInside)];
           
            cell.model = self.model;
            
            return cell;
            
        }

    }else if (indexPath.section == 8){
        
        if (indexPath.row == 0) {
            OrderHeardTableViewCell *cell = [OrderHeardTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            cell.heardName.text = @"单据信息";
            cell.collectionBtn.hidden = YES;

            
            return cell;
        }else{
            JYLookPhotoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYLookPhotoTableViewCell class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 2.0;
            cell.layer.masksToBounds = YES;
            cell.contentLabel.textColor = RGB(51, 51, 51);

            if (self.model.enclosure == nil || [self.model.enclosure isEqual:[NSNull null]] || self.model.enclosure.length <= 0 ) {
                
            }else{
                
                [cell layoutPhotoView:self.model.annexDescription photo:self.model.enclosure];
                
            }
            
            return cell;
            
        }
        
    }else{
        
        OrderDetailTwoCell *cell = [OrderDetailTwoCell cellWithOrderTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTitle.textColor = RGB(102, 102, 102);

        if (indexPath.row == 0) {

            cell.orderTitle.text = @"订单状态:";
            cell.orderTitle.textColor = RGB(102, 102, 102);;
            [cell setOrderStutas:model];
           
        }else if (indexPath.row == 1){
            cell.orderTitle.text = @"订单编号:";
            cell.orderContent.text = model.orderNo;
            
        
        }else if (indexPath.row == 2){
            cell.orderTitle.text = @"下单时间:";
            cell.orderContent.text = model.createDate;
        }else{
            cell.orderTitle.hidden = YES;
            cell.orderContent.hidden = YES;
        }

     return cell;
    
    
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else if (section == 1){
        
        if ([self.model.isLieu isEqualToString:@"0"]) {
            return 0.001;
        }else{
            return 9;
        }
    }else if (section == 3) {
        return 0.001;
    }else if (section == 5){
        if (self.model.service.length <= 0) {
             return 0.001;
        }else{
            return 9;
        }
        
    }else if (section == 7){
        
        if ([self.model.basicStatus isEqualToString:@"0"]) {
            
            return 0.001;
            
        }else{
            return 9;
        }
    }else if (section == 8){
        
//        if ([self.model.basicStatus isEqualToString:@"0"]) {
        
//            return 0.001;
        
//        }else{
        
            return 9;
//        }
    }else{
        return 9;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

     
    if (indexPath.section == 0) {
        
        return 190;
        
    }else if (indexPath.section == 1){
        
        return  49;
        
    }else if (indexPath.section == 2){
        
        return  49;
        
    }else if (indexPath.section == 3){
    
        return 44;
    }else if (indexPath.section == 4){
    
        return 140;
    
    }else if (indexPath.section == 5){

        if (indexPath.row == 0) {
            return 49;
        }else{
            return UITableViewAutomaticDimension;
 
        }
        
    }else if (indexPath.section == 6){
        
        if (indexPath.row == 0) {
            return 49;
        }else{
            
            return 99;
        }
        
    }else if ( indexPath.section == 7){
        if (indexPath.row == 0) {
            return 49;
        }else{
            
            return 156;
        }
    }else if ( indexPath.section == 8){
        if (indexPath.row == 0) {
            return 49;
        }else{
            
            return UITableViewAutomaticDimension;
        }
    }else{
        if (indexPath.row == 3) {
            return 10;
        }else{
            return 24;

        }
    }
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    contenView.backgroundColor = BgColorOfUIView;
    
    return contenView;
        

}
- (void)moneydetailButtonClick:(UIButton *)btn{
    
    TimeOutFeeView *view = [[TimeOutFeeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.title = @"收费详情";
    view.nameArr = @[@"超时时间",@"超时费用",@"我的出价"];
    view.valueArr = @[@"30分钟",@"¥30",@"¥500"];
    [view showTimeOutView];
 
}
//点击收藏
- (void)collectionBtnClick:(UIButton *)button{
    
    if ([self.model.jyTruckergroup.isCollection isEqualToString:@"0"]) {
        MessageRequsetData *messageData = [[MessageRequsetData alloc] init];
        messageData.delegate = self;
        [messageData requestDataCollection:nil UserPhone:nil DriverPhone:self.model.jyTruckergroup.phone];

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新UI
            [MBProgressHUD showError:@"不可重复收藏"];

        });

    }
    
    
}
//收藏成功zaZ
- (void)requestDataForCollectionSuccess:(NSDictionary *)resultDic{
    
    [MBProgressHUD showSuccess: @"收藏成功"];
    self.model.jyTruckergroup.isCollection = @"1";

    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:6];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];



}

- (void)requestDataForCollectionFailed:(NSError *)error{
    
    
}
- (void)evaluationBtnClick:(UIButton *)button{
    
    LookEvaluateViewController *evaluateVC = [[LookEvaluateViewController alloc] init];
    evaluateVC.driverPhone = self.model.jyTruckergroup.phone;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderEndSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderbeginWorking" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getDrivers" object:nil];
}


- (void)callDriverPhone:(UIButton *)sender {
    
    DriverInfoMode *drModel = self.model.jyTruckergroup;
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", drModel.phone];
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
}
- (NSAttributedString *)infoLabelAttibutedString{
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"以上价格并未包括路桥费，停车场费及所有杂费，请上车前于司机确认收费。"];
    
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:12],NSForegroundColorAttributeName:RGB(153, 153, 153),};
    
    [attStr setAttributes:firstAttributes range:NSMakeRange(0,attStr.length)];
    
    NSDictionary * secondAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:12],NSForegroundColorAttributeName:BGBlue,};
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@"点击查看收费详情"];
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    [attStr appendAttributedString:secondPart];
    
    return attStr;
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
