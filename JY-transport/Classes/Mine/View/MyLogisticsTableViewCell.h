//
//  MyLogisticsTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/11/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginticModel;
@class JYCompanyModel;
@interface MyLogisticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIButton *IntroductionBtn;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;

@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (weak, nonatomic) IBOutlet UIButton *outletsBtn;
@property (weak, nonatomic) IBOutlet UIButton *LogisticsOrdersBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)LoginticModel *model;
@property (nonatomic,strong)JYCompanyModel *comModel;

@end
