//
//  LookEvaluteTableViewCellOne.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookEvaluteTableViewCellOne : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *serviceStartView;
@property (weak, nonatomic) IBOutlet UIView *attitudeStartView;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;



- (void)setStartView:(NSString*)sum attitude:(NSString *)attitude speed:(NSString *)speed;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
