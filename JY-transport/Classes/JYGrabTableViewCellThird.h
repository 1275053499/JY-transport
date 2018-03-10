//
//  JYGrabTableViewCellThird.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYCargoDetailsModel;
@interface JYGrabTableViewCellThird : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameConstraintLeading;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setvalueforCellRowTwo:(JYCargoDetailsModel *)model;
- (void)setvalueforCellRowThree:(JYCargoDetailsModel *)model isInsure:(int)isInsure;

@end
