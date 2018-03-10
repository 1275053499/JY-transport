//
//  payOrderNumberCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "payOrderNumberCell.h"

@implementation payOrderNumberCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"payOrderNumberCell";
    payOrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}
@end
