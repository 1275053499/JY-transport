//
//  LookEvaluteTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateModel.h"
#import "JYEvaluateModel.h"
@interface LookEvaluteTableViewCell : UITableViewCell
@property (nonatomic,strong)EvaluateModel *evaluateodel;

@property (nonatomic,strong)JYEvaluateModel *jyevaluateodel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
