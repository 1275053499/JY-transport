//
//  TimeOutFeeView.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeOutFeeView : UIView
@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong)NSArray *valueArr;
@property (nonatomic,strong)NSString *title;
- (void)showTimeOutView;
@end
