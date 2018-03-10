//
//  AddressCellTableViewCell.m
//  JY-transport
//
//  Created by 王政的电脑 on 17/5/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "AddressCellTableViewCell.h"

@implementation AddressCellTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AddressCellTableViewCell";
    AddressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

@end
