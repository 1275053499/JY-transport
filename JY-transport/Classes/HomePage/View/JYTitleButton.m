//
//  JYTitleButton.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYTitleButton.h"
#define IWTitleButtonImageW 40
@implementation JYTitleButton

+(instancetype)titleButton
{

    return [[self alloc]init];


}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont fontWithName:Default_APP_Font size:15];
        self.imageView.contentMode = UIViewContentModeCenter;
        ;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
      
        // 背景
        [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;

    
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = IWTitleButtonImageW;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width - IWTitleButtonImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
