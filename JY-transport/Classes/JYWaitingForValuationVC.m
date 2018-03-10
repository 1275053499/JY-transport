//
//  JYWaitingForValuationVC.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWaitingForValuationVC.h"

#import "JYGrabServiceTableViewCell.h"
#import "JYORderNumberTableViewCell.h"
#import "JYGrabValueTableViewCell.h"
#import "JYGrabTableViewCellThird.h"
#import "JYOrderAddressTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYLookPhotoViewController.h"
//#import "JYConfirmPriceViewController.h"
@interface JYWaitingForValuationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation JYWaitingForValuationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(back)];
    self.navigationItem.title = @"订单详情";
    [self createTableView];
    [self creatBtn];
}
- (void)creatBtn{
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - 64,135,50);
    [sureBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake(135, ScreenHeight - 64- 50,(ScreenWidth - 135), 50);
    [yueBtn setTitle:@"等待估价" forState:UIControlStateNormal];
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [yueBtn setBackgroundColor:BGBlue];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:yueBtn];
    
}
- (void)cancelBtnClick:(UIButton *)btn{
    
   

    
}
- (void)sureBtnClick:(UIButton*)btn{
    
//    JYConfirmPriceViewController *vc = [[JYConfirmPriceViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth , ScreenHeight -64 -50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.estimatedRowHeight = 50.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
//  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row == 1){
            return 92;
        }else if (indexPath.row == 2){
            return 40;
        }else if (indexPath.row == 3){
            return 40;
        }else{
            return 40;
        }
       
    }else if (indexPath.section == 1){
        
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 2){
        
        return 44;
    }else{
        return 83;
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            JYGrabValueTableViewCell *cell = [JYGrabValueTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sendType.text = @"预约9.10（周五）15:22";

            return cell;
            
        }else if (indexPath.row == 1){
            
            JYOrderAddressTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYOrderAddressTableViewCell class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            return cell;
            
        }else if (indexPath.row == 2){
            JYGrabTableViewCellThird *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabTableViewCellThird class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = @"名称： 电脑桌";
//            cell.midLabel.text = @"类型： 贵重物品";
            cell.lastLabel.text = @"";

            
            return cell;
        }else if (indexPath.row == 3){
            JYGrabTableViewCellThird *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabTableViewCellThird class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameLabel.text = @"重量： 60kg";
            cell.midLabel.text = @"数量： 10件";
            cell.lastLabel.text = @"包装： 木箱";
            
            return cell;

        }else{
            JYGrabTableViewCellThird *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabTableViewCellThird class]) owner:nil options:0][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameLabel.text = @"体积： 100";
            cell.midLabel.textColor = BGBlue;
            cell.midLabel.text = @"已投保";
            cell.lastLabel.text = @"";

            
            return cell;

        }
        
    }else if (indexPath.section == 1){
        
        JYGrabServiceTableViewCell  *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYGrabServiceTableViewCell class]) owner:nil options:0][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

//        [cell layoutServiceView];
        
        return cell;
    }else if (indexPath.section == 2){
        
        JYDescripeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYDescripeTableViewCell class]) owner:nil options:0][0];
        cell.size = CGSizeMake(ScreenWidth -14, 44);
        [cell rounded:2.0];
        cell.naemLabel.text = @"查看货物描述";
        return cell;

       
    }else{
        
        JYORderNumberTableViewCell  *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYORderNumberTableViewCell class]) owner:nil options:0][0];
        cell.size = CGSizeMake(ScreenWidth -14, 83);
        [cell rounded:2.0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
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
    if (section == 1) {
        return 0;
    }else{
         return 9;
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        JYLookPhotoViewController *vc = [[JYLookPhotoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
