//
//  JYSendPhotoTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSendPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imgBackView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
