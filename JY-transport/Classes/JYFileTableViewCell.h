//
//  JYFileTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *file;
@property (weak, nonatomic) IBOutlet UIButton *smallFile;
@property (weak, nonatomic) IBOutlet UIButton *bigFile;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
