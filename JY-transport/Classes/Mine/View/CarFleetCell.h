//
//  CarFleetCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTeamMode.h"
#import "HCSStarRatingView.h"

@protocol CarFleetCellDelegate <NSObject>



-(void)tableviewReloadDate;


@end


@interface CarFleetCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *carBeseState;
@property (weak, nonatomic) IBOutlet UIImageView *drivericon;

@property (weak, nonatomic) IBOutlet UILabel *carNumber;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *cartype;
@property (weak, nonatomic) IBOutlet UIButton *lookForCarButton;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneButton;
@property (nonatomic,strong)CarTeamMode *carMode;
@property (weak, nonatomic) IBOutlet UIView *starSuperVIew;
@property (nonatomic,strong)HCSStarRatingView *starView;



//@property(nonatomic,strong)id<CarFleetCellDelegate>delegate;
@end
