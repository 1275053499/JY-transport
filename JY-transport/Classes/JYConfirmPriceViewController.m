//
//  JYConfirmPriceViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYConfirmPriceViewController.h"

#import "JYConfirmTableViewCell.h"
#import "JYConfirmTableViewCellSecond.h"
#import "JYConfirmTableViewCellThird.h"
#import "JYLookEvaluateViewController.h"
#import "JYLookOutletsViewController.h"
#import "JYLookCompanyViewController.h"
#import "JYHomeRequestDate.h"
#import "JYWaitingAnimationViewController.h"
#import "JYCompanyModel.h"
#import "JYMessageRequestData.h"

@interface JYConfirmPriceViewController ()<UITableViewDelegate,UITableViewDataSource,JYHomeRequestDateDelegate,JYMessageRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)JYCompanyModel *companymodel;
@end

@implementation JYConfirmPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"订单详情";
    [self creatTableView];
//    _logisticsId = @"";
//    [self creatBtn];

}

- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 -50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
}
//- (void)creatBtn{
//    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(0, ScreenHeight - 50 - 64 - 118 - 9,135,50);
//    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//    [cancelBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
//    cancelBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//    
//    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.frame = CGRectMake(135, ScreenHeight - 64 - 50 - 118 - 9,(ScreenWidth - 135), 50);
//    [sureBtn setTitle:@"确定服务" forState:UIControlStateNormal];
//    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
//    [sureBtn setBackgroundColor:RGBA(17,138 ,231, 1)];
//    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sureBtn];
//
//}


- (void)viewWillAppear:(BOOL)animated{
    
    if ([_fromWhichVC isEqualToString:@"JYOrderDetailViewController"]) {
        [self requsetGetCompanyInfo];
    }else{
        
        [self queryLogisticsCompanyValuation];
 
    }

}
//获取物流公司估价
- (void)queryLogisticsCompanyValuation{
    JYWaitingAnimationViewController *animationVC =(JYWaitingAnimationViewController *) self.parentViewController;
    if ([animationVC isKindOfClass:[JYWaitingAnimationViewController class]]) {
        
     NSString *orderID = animationVC.orderID;
        JYHomeRequestDate *manager = [JYHomeRequestDate shareInstance];
        manager.delegate = self;
        [manager requsetInquiryQuotation:@"app/logisticsorder/inquiryQuotation" orderID:orderID];

    }
  
}


- (void)requsetInquiryQuotationSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
         _companymodel = [JYCompanyModel mj_objectWithKeyValues:resultDic];
        self.logisticsId = _companymodel.id;
        [self.tableView reloadData];

    }
}

- (void)requsetInquiryQuotationFailed:(NSError *)error{
    
    
}



//查看物流公司信息
- (void)requsetGetCompanyInfo{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager requsetGetCompanyInfoByLogisticsId:@"app/logisticsgroup/getGroupById" logisticsId:self.logisticsId];
}

- (void)requsetGetCompanyInfoSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"404"] || [message isEqualToString:@"1"] || [message isEqualToString:@"500"]) {
        
    }else{
        
        _companymodel = [JYCompanyModel mj_objectWithKeyValues:resultDic];
        
        [self.tableView reloadData];
        
    }

    
}

- (void)requsetGetCompanyInfoFailed:(NSError *)error{
    
    
}
//- (void)cancelBtnClick:(UIButton *)button{
//    
//    
//}
//- (void)sureBtnClick:(UIButton *)button{
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return 3;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        JYConfirmTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYConfirmTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", _companymodel.evaluation];
        
        if ([_fromWhichVC isEqualToString:@"JYOrderDetailViewController"]) {
            cell.hidden = YES;
        }
        return cell;
    }else if (indexPath.row == 1){
        
        JYConfirmTableViewCellSecond *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYConfirmTableViewCellSecond class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.comModel = _companymodel;
        return cell;
    }else{
        JYConfirmTableViewCellThird *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYConfirmTableViewCellThird class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.lookEvaluationBtn addTarget:self action:@selector(lookEvaluationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.lookCompanyBtn addTarget:self action:@selector(lookCompanyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.lookOutletsBtn addTarget:self action:@selector(lookOutletsBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        if ([_fromWhichVC isEqualToString:@"JYOrderDetailViewController"]) {
            
            return 0;

        }else{
            
            return 103;
            
        }
        
    }else if (indexPath.row ==1){
        return 79;
    }else{
        
        return 50;
    }
}
- (void)lookEvaluationBtnClick:(UIButton *)btn{
    
    JYLookEvaluateViewController *vc = [[JYLookEvaluateViewController  alloc] init];
    vc.logisticsId = _companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)lookCompanyBtnClick:(UIButton *)btn{
    
    JYLookCompanyViewController *vc = [[JYLookCompanyViewController alloc] init];
    vc.introductions = _companymodel.introductions;
    vc.icon = _companymodel.icon;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lookOutletsBtnClick:(UIButton *)btn{
    
    JYLookOutletsViewController *vc = [[JYLookOutletsViewController alloc] init];
    vc.logisticsid = self.logisticsId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
