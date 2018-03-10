//
//  JYLookLogisticsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookLogisticsViewController.h"
#import "JYLooklogisticsTableViewCell.h"
#import "JYLookLogisticsTableViewCellSecond.h"
#import "JYMessageRequestData.h"
#import "JYTransportModel.h"
@interface JYLookLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource,JYMessageRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *transportArr;
@end

@implementation JYLookLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _transportArr = [NSArray array];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    [self createTableView];
    [self queryGetTrackingByNumber];
}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth , ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)queryGetTrackingByNumber{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    if (self.transportNumber.length <= 0 || self.transportNumber == nil || [self.transportNumber isEqual:[NSNull null]]) {
        
    }else {
        
        [manager requestGetTrackingByNumber:@"app/tracking/getTrackingByNumber" transportNumber:self.transportNumber];
        
    }
    
}
- (void)requestGetTrackingByNumberSuccess:(id)resultDic{
    
    self.transportArr= [JYTransportModel mj_objectArrayWithKeyValuesArray:resultDic];
    
    [self.tableView reloadData];
    
}

- (void)requestGetTrackingByNumberFailed:(NSError *)error{
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        
        return self.transportArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 87;
        
    }else{
        return 50;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        JYLooklogisticsTableViewCell *cell = [JYLooklogisticsTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.orderDetailModel;
        return cell;
        
    }else{
        
        JYLookLogisticsTableViewCellSecond *cell = [JYLookLogisticsTableViewCellSecond cellWithTableView:tableView];
        cell.statuName.font = [UIFont fontWithName:Default_APP_Font_Regu
                                              size:14];
        cell.timeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
        cell.statuName.textColor = RGB(153, 153, 153);
        cell.timeLabel.textColor = RGB(153, 153, 153);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.statuName.textColor = BGBlue;
            cell.timeLabel.textColor = BGBlue;
            JYTransportModel *model = self.transportArr[indexPath.row];
            cell.statuName.text = model.content;
            NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
            NSString *operation = array[0];
            cell.timeLabel.text = operation;
            
            
            
            return cell;
            
        }
        
        if (self.transportArr.count > 0) {
            
            if (indexPath.row == self.transportArr.count - 1) {
                
                cell.imgView.image = [UIImage imageNamed:@"icon_huisexian"];
                JYTransportModel *model = self.transportArr[indexPath.row];
                cell.statuName.text = model.content;
                
                NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
                NSString *operation = array[0];
                cell.timeLabel.text = operation;
                
                return cell;
            }else{
                
                cell.imgView.image = [UIImage imageNamed:@"icon_jingguo"];
                JYTransportModel *model = self.transportArr[indexPath.row];
                cell.statuName.text = model.content;
                NSArray *array = [model.operationTime componentsSeparatedByString:@"."];
                NSString *operation = array[0];
                cell.timeLabel.text = operation;
                return cell;
                
            }
            
        }
        
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
    return 9;
    
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

