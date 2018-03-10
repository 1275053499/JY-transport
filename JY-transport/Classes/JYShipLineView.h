//
//  JYShipLineView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYShipLineView : UIView

@property (weak, nonatomic) IBOutlet UIButton *lookStartAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookEndAddressBtn;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *startSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSubLabel;

@end
