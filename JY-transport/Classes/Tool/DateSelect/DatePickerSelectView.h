//
//  DatePickerSelectView.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class DatePickerSelectView;

@protocol DatePickerSelectViewDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN


- (void)datePickerViewSelect:(NSString *)dateStr;

@end


@interface DatePickerSelectView : UIPickerView

@property (nonatomic, weak, nullable) id<DatePickerSelectViewDelegate> datePickerDelegate;

- (void)showPickView;

NS_ASSUME_NONNULL_END

@end






