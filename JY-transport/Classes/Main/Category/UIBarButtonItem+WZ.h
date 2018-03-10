//
//  UIBarButtonItem+WZ.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WZ)
/**
 *  左边显示图片的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

/**
 *  右边显示图片的item
 *
 *  @param action   监听方法
 */

+ (UIBarButtonItem *)addRight_ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

/**
 *  右边两个item，第一个文字，第二个图片
 *
 */
+ (UIBarButtonItem *)addRight_ItemWithIconAndTitle:(NSString *)itemTitle target:(id)target firstAction:(SEL)firstAction icon:(NSString *)icon highIcon:(NSString *)highIcon secondAction:(SEL)secondAction;

/**
 *  右边文字的item
 *
 */

+ (UIBarButtonItem *)addRight_ItemWithTitle:(NSString *)itemTitle target:(id)target action:(SEL)action;

@end
