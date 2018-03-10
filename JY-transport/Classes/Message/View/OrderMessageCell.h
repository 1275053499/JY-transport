//
//  OrderMessageCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OrderMessageCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *place;




@end
