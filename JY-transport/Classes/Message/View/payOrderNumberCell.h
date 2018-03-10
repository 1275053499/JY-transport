//
//  payOrderNumberCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payOrderNumberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabe;
@property (weak, nonatomic) IBOutlet UILabel *subTitileLabel;
@property (weak, nonatomic) IBOutlet UILabel *detLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@end
