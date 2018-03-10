//
//  TMPassWordView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/28.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TMTextFieldView.h"



@interface TMPassWordView : UIView


@property (nonatomic,strong)TMTextFieldView *textFieldView;

@property (nonatomic,strong)NSString *title;

- (instancetype)initWithFrame:(CGRect)frame WithDelegate:(id)objVC;



- (void)deleteAllPassWords;

@end
