//
//  OrderAlertView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
/**
 *  点击按钮触发事件
 *
 *  @param states  点击的按钮是取消还是接受
 */
@protocol OrderAlertViewDelegate <NSObject>
-(void)ButtonDidCilckedWithCancleOrConfirm:(NSString *)states;
@end
@interface OrderAlertView : UIView
/* 创建提示框View */
@property (nonatomic, strong) UIView *alertView;
/* 取消按钮 */
@property (nonatomic,strong) UIButton *cancelButton;
/* 确定 */
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,weak) id <OrderAlertViewDelegate> delegate;
- ( instancetype )initWithFrame:(CGRect)frame withGroupNumber:(NSInteger) num;
@property(nonatomic,strong)OrderModel *model;
@end
