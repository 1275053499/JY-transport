//
//  EditPersonalSexView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EditPersonalSexView.h"
#import "cancelTableCell.h"

@interface EditPersonalSexView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *setTableView;
@property(nonatomic,strong)UIButton *lastbutton;//上一个btn
@end
@implementation EditPersonalSexView



-(void)showSexView{
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *current = [UIApplication sharedApplication].keyWindow;
    [current addSubview:self];
    self.underView.layer.cornerRadius = 5;
    self.underView.layer.masksToBounds = YES;

    [self creatTableView];
    [UIView animateWithDuration:0.4 animations:^{
         self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseOut)];

        
    }];
}

-(void)dissMIssSexView{
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
//创建tabelView和取消确定 button
- (void)creatTableView{
    self.setTableView.delegate =self;
    self.setTableView.dataSource = self;
    self.setTableView.backgroundColor = [UIColor whiteColor];
    self.setTableView.layer.cornerRadius = 6;
    self.setTableView.scrollEnabled =NO;
    
}
- (void)sureCancelButtonClick:(NSString *)btn{
//    NSLog(@"======%@",self.orderId);
//    
//    [[NetWorkHelper shareInstance]Post:cancelOrder parameter:@{@"cancelType":@"",@"orderNo":self.orderId,@"remark":@""} success:^(id responseObj) {
//        
//        
//        if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
//            
//            
//            
//            [self dissMIssView];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderCancelSuccess" object:nil];
//            
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"RobOrderSuccess"];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD showError:@"网络异常" toView:self];
//    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMIssSexView];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cancelTableCell *cell = [cancelTableCell cellWithOrderTableView:tableView];
    cell.titleLabel.text = self.dataArr[indexPath.row];
    cell.seleImage.tag = indexPath.row+800;
    [cell.seleImage setImage:[UIImage imageNamed:@"icon_weixuanzhong"] forState:UIControlStateNormal];
    [cell.seleImage setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateSelected];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = _dataArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(changeLabelValue:)]) {
        [self.delegate changeLabelValue:str];
        [self sureCancelButtonClick:str];
    }
    UIButton *button = [tableView viewWithTag:indexPath.row+800];
    if (button.selected) {
        button.selected = YES;
        
    }else{
        self.lastbutton.selected = NO;
        button.selected = YES;
        self.lastbutton= button;
        
    }
    
    
    
    [self dissMIssSexView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
