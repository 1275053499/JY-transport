//
//  JYShipServicesTabcell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYShipServicesTabcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *servicesLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceRightBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
