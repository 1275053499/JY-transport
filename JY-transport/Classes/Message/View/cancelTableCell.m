//
//  cancelTableCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "cancelTableCell.h"

@implementation cancelTableCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"cancelTableCell";
    cancelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
      
        
        
    }
    return cell;
}
@end
