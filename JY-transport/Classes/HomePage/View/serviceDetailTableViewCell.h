//
//  serviceDetailTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface serviceDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linViewBottomConstraint;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setServiceBtnImage:(NSIndexPath *)indexPath serviceArr:(NSArray *)arr;
@end
