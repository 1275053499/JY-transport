//
//  HongKongCityPickerView.h
//  JY-transport
//
//  Created by 闫振 on 2017/10/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HongKongCityPickerView;

@protocol HongKongCityPickerViewDelegate <NSObject>


/**
 *  告诉代理，用户选择了省市区
 *
 *  @param picker   picker
 *  @param province 省
 *  @param city     市
 *  @param district 区
 */
- (void)HongKongCityPickerView:(HongKongCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city;
@end

@interface HongKongCityPickerView : UIPickerView

@property (nonatomic, weak, nullable) id<HongKongCityPickerViewDelegate> hongkongDelegate;

- (void)showPickView;

@end
