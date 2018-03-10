//
//  serviceDetailTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "serviceDetailTableViewCell.h"

@implementation serviceDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"serviceDetailTableViewCell";
    serviceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

- (void)setServiceBtnImage:(NSIndexPath *)indexPath serviceArr:(NSArray *)arr{
    
    [self.leftBtn setTitleColor:RGB(153, 153, 153) forState:(UIControlStateNormal)];
    [self.leftBtn setTitleColor:BGBlue forState:(UIControlStateSelected)];

    if (indexPath.row == 1) {
        self.leftBtn.tag = 2001;
        self.rightBtn.tag = 2002;
       
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_gaosu_huise"] forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_gaosu"] forState:(UIControlStateSelected)];
        [self.leftBtn setTitle:@"  高速" forState:(UIControlStateNormal)];
       
        
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_xuyaoshoutuiche"] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_xuyaoshoutuiche_lanse"] forState:(UIControlStateSelected)];
        [self.rightBtn setTitle:@"  手推车" forState:(UIControlStateNormal)];
        if ([arr containsObject:@"1"]) {
            self.leftBtn.selected = YES;
        }
        if ([arr containsObject:@"2"]) {
            self.rightBtn.selected = YES;
        }
    }else if (indexPath.row == 2){
        self.leftBtn.tag = 2003;
        self.rightBtn.tag = 2004;
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_xuyaobanyun_huise"] forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_xuyaobanyun"] forState:(UIControlStateSelected)];
        [self.leftBtn setTitle:@"  搬运" forState:(UIControlStateNormal)];

        [self.rightBtn setImage:[UIImage imageNamed:@"icon_qianhuidan_yuan"] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_qianhuidan_yuan_lanse"] forState:(UIControlStateSelected)];
        [self.rightBtn setTitle:@"  签回单" forState:(UIControlStateNormal)];
        if ([arr containsObject:@"3"]) {
            self.leftBtn.selected = YES;
        }
        if ([arr containsObject:@"4"]) {
            self.rightBtn.selected = YES;
        }
        
    }else if (indexPath.row == 3){
        
        self.leftBtn.tag = 2005;
        self.rightBtn.tag = 2006;
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_yuejie_yuan"] forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_yuejie_yuan_lanse"] forState:(UIControlStateSelected)];
        [self.leftBtn setTitle:@"  月结" forState:(UIControlStateNormal)];

        [self.rightBtn setImage:[UIImage imageNamed:@"icon_huodaofukuan_yuan"] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_huodaofukuan_yuan_lanse"] forState:(UIControlStateSelected)];
        [self.rightBtn setTitle:@"  收货人付款" forState:(UIControlStateNormal)];
        [self.rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 33, 0, 0)];
        if ([arr containsObject:@"5"]) {
            self.leftBtn.selected = YES;
        }
        if ([arr containsObject:@"6"]) {
            self.rightBtn.selected = YES;
        }
        
    }else if (indexPath.row == 4){
        
        self.leftBtn.tag = 2007;
        self.rightBtn.tag = 2008;

        [self.leftBtn setImage:[UIImage imageNamed:@"icon_weibanche_huise"] forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_weibanche"] forState:(UIControlStateSelected)];
        [self.leftBtn setTitle:@"  尾板车" forState:(UIControlStateNormal)];
        [self.leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 17, 0, 0)];

        
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_xiangshiche_huise"] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_xiangshiche"] forState:(UIControlStateSelected)];
        [self.rightBtn setTitle:@"  厢式车" forState:(UIControlStateNormal)];
        if ([arr containsObject:@"7"]) {
            self.leftBtn.selected = YES;
        }
        if ([arr containsObject:@"8"]) {
            self.rightBtn.selected = YES;
        }
        
    }
  
   
  

}
@end
