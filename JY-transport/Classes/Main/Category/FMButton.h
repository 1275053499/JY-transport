//
//  FMButton.h
//  Haohaogouwu
//
//  Created by 王政 on 2016/11/23.
//  Copyright © 2016年 xieguanghui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMButton;
typedef void(^ClickMessageBlock)(FMButton *);
@interface FMButton : UIButton
/** 回调 */
@property (nonatomic, copy) ClickMessageBlock block;

+ (instancetype)createFMButton;

@end
