//
//  JYConfirmTableViewCellSecond.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginticModel;
@class JYCompanyModel;
@interface JYConfirmTableViewCellSecond : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyPhone;
@property (nonatomic,strong)LoginticModel *model;
@property (nonatomic,strong)JYCompanyModel *comModel;
@end
