//
//  linkmanCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "linkmanCell.h"

@implementation linkmanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"linkmanCell";
    linkmanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
      
  
    }
    return cell;
    
}

@end
