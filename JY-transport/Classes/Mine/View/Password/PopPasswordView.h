//
//  PopPasswordView.h
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTextFieldView.h"


@interface PopPasswordView : UIView


////用来显示内容
@property(nonatomic,retain)UILabel *tip;

@property (nonatomic,strong)TMTextFieldView *tmPasswordView;

@property (nonatomic,strong)NSString *money;


@end
