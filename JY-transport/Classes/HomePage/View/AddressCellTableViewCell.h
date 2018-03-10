//
//  AddressCellTableViewCell.h
//  JY-transport
//
//  Created by 王政的电脑 on 17/5/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (weak, nonatomic) IBOutlet UILabel *subCityName;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
