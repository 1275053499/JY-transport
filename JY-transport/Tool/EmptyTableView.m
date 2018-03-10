//
//  EmptyTableView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EmptyTableView.h"

@interface EmptyTableView ()

@property (nonatomic,strong)UIView *bottomView;

@end

@implementation EmptyTableView

- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger)rowCount frame:(CGRect)frame
{
    [_bottomView removeFromSuperview];
  
    if (rowCount == 0) {
        
        _bottomView = [[UIView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = BgColorOfUIView;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_null"]];
        imgView.frame = CGRectMake((ScreenWidth - 100)/2, 140 , 100, 100);
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.frame = CGRectMake(50, 252, ScreenWidth - 100, 20);
        messageLabel.text = message;
        messageLabel.font = [UIFont fontWithName:Default_APP_Font size:15];
        messageLabel.textColor = RGB(153, 153, 153);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:imgView];
        [_bottomView addSubview:messageLabel];
        [self addSubview:_bottomView];
    } else {
        
        [_bottomView removeFromSuperview];

    }

    


}

@end
