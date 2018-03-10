//
//  EditorTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineVIew;
@property (weak, nonatomic) IBOutlet UIImageView *accessImgView;


@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
