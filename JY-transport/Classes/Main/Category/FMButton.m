//
//  FMButton.m
//  Haohaogouwu
//
//  Created by 王政 on 2016/11/23.
//  Copyright © 2016年 xieguanghui. All rights reserved.
//

#import "FMButton.h"

@implementation FMButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(FMButton *)btn
{
    if (_block) {
        _block(btn);
    }
}

+ (instancetype)createFMButton
{
    return [FMButton buttonWithType:UIButtonTypeCustom];
}


@end
