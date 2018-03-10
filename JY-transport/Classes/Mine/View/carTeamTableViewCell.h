//
//  carTeamTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverInfoMode.h"
@interface carTeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (nonatomic,strong)DriverInfoMode *driverinfoMode;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
