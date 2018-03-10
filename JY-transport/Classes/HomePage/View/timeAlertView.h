//
//  timeAlertView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeNum;
@property (weak, nonatomic) IBOutlet UILabel *driverNum;
@property (weak, nonatomic) IBOutlet UILabel *distanceNum;
@property (weak, nonatomic) IBOutlet UIView *calloutView;
@property (nonatomic,strong)NSString *timeOrDistance;
@property (nonatomic,strong)NSString *distanceStr;


- (void)setAnationView;
@end
