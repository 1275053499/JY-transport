//
//  CouponLeftTableView.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineCouponModel;
@interface CouponLeftTableView : UITableView

@property (nonatomic,strong)NSString *leftRight;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)void(^BlockMineCoupon)(MineCouponModel *couponModel); 
@end
