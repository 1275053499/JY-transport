//
//  EditorPersonTabCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorPersonTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
