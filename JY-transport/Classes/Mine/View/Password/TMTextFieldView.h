//
//  TMTextFieldView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/30.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TMTextFieldView;

@protocol  TMTextFieldViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(TMTextFieldView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(TMTextFieldView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(TMTextFieldView *)passWord;


@end


@interface TMTextFieldView : UIView

@property (nonatomic,strong)UITextField *pwdTextField;
@property (nonatomic, strong) NSString *pwdPassword;//保存密码的字符串
@property (nonatomic,assign)CGFloat Square_Width;
@property (weak, nonatomic)  id<TMTextFieldViewDelegate> delegate;

- (void)deleteAllPassWord;

@end
