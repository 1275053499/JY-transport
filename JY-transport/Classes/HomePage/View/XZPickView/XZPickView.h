//
//  XZPickView.h
//  XZPickView
//
//  Created by 赵永杰 on 17/3/24.
//  Copyright © 2017年 zhaoyongjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZPickView;


@protocol XZPickViewDelegate <NSObject>


- (void)getDataFromConfirmButtonClick:(NSString*)selectDate;


@end

@interface XZPickView : UIView

@property (nonatomic, weak) id<XZPickViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)show;
- (void)dismiss:(UIButton*)btn;


@end
