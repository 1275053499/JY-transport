//
//  oneTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "oneTableViewCell.h"

@implementation oneTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"oneTableViewCell";
    oneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}
@end
