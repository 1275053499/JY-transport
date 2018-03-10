//
//  UIBarButtonItem+WZ.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "UIBarButtonItem+WZ.h"


@implementation UIBarButtonItem (WZ)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, - 5 , 0, 0);

    return [[UIBarButtonItem alloc] initWithCustomView:button];

}
+ (UIBarButtonItem *)addRight_ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0  , 0, -5);
    return [[UIBarButtonItem alloc] initWithCustomView:button];

}
+ (UIBarButtonItem *)addRight_ItemWithTitle:(NSString *)itemTitle target:(id)target action:(SEL)action{
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    [rightbBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    return [[UIBarButtonItem alloc] initWithCustomView:rightbBarButton];

}
+ (UIBarButtonItem *)addRight_ItemWithIconAndTitle:(NSString *)itemTitle target:(id)target firstAction:(SEL)firstAction icon:(NSString *)icon highIcon:(NSString *)highIcon secondAction:(SEL)secondAction{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [firstBtn setTitle:itemTitle forState:(UIControlStateNormal)];
    [firstBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    firstBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    [firstBtn addTarget:target action:firstAction forControlEvents:UIControlEventTouchUpInside];
    firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [firstBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -2)];
    [view addSubview:firstBtn];
    
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(40, 0, 40, 44);
    [secondButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [secondButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [secondButton addTarget:target action:secondAction forControlEvents:UIControlEventTouchUpInside];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    [view addSubview:secondButton];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}
@end
