//
//  JYGrabServiceTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGrabServiceTableViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)layoutServiceView:(NSString *)service;

@end
