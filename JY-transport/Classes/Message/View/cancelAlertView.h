//
//  cancelAlertView.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cancelAlertViewDelegate <NSObject>


@optional

-(void)cancelReasonButtonClick:(NSInteger)index content:(NSString *)str;



@end
@interface cancelAlertView : UIView

@property(nonatomic,copy)void (^GlodeBottomView)(NSInteger index ,NSString *string);
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)id<cancelAlertViewDelegate>delegate;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,strong)UIButton *sureButton;

+(id)GlodeBottomView;
-(void)show;
-(void)dissMIssView;
@end
