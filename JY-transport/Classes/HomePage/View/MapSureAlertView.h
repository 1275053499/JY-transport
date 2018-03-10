//
//  MapSureAlertView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "driverModel.h"
#import "OrderModel.h"
@interface MapSureAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *scoreSureButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *lookEvaluate;

@property (nonatomic,strong)OrderModel *orderMode;

@property (weak, nonatomic) IBOutlet UIButton *scoreCancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *CertificationImg;
-(void)showSureAlertView;
@end
