//
//  platformBidView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface platformBidView : UIView
- ( instancetype )initWithFrame:(CGRect)frame;

@property(nonatomic,copy)NSString *carType;

@property(nonatomic,assign)double savedistance;

@property(nonatomic,copy)NSString *money;

@end
