//
//  oneTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface oneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *startPlaceView;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceDistrict;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *placeType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
