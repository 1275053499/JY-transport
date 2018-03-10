//
//  MainView.m
//  segmentController
//
//  Created by 77 on 2017/7/20.
//  Copyright © 2017年 77. All rights reserved.
//

#import "MainView.h"
#import "UIButton+LayoutBtn.h"
#import "DeliverGoodsViewController.h"
#import <IQKeyboardManager.h>
@implementation MainView

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    [self scrollVc1];
}
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    for (int i = 0; i < titleArray.count; i++) {
        CGFloat width = [self.titleArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18]}].width;
        titleWidth = width + titleWidth;
    }
    [self cretBtnView];
    [self addNotification];
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeItem:) name:@"changeItem" object:nil];

}
- (void)setBtnViewHeight:(NSInteger)btnViewHeight {
    _btnViewHeight = btnViewHeight;
    [self createScroll];
    [self addSubview:self.pageScroll];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor= [UIColor whiteColor];
        _btnView = [[UIView alloc]init];
        _btnView.frame = CGRectMake(0,0,self.frame.size.width,self.btnViewHeight);
        [self CreatelineView];
        [self addSubview:_btnView];
    }
    return self;
}

- (void)layoutSubviews {
    
}

- (void)createScroll {
    _pageScroll = [[UIScrollView alloc] init];
    _pageScroll.delegate = self;
    _pageScroll.pagingEnabled = YES;
    _pageScroll.bounces = NO;
    _pageScroll.scrollEnabled = NO;
    _pageScroll.frame = CGRectMake(0,self.btnViewHeight, [[UIScreen mainScreen] bounds].size.width, self.bounds.size.height);
    _pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width*3, 0);
    
}



- (void)cretBtnView {
    
    CGFloat ViewX = 0;

    _btnView.frame = CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,self.btnViewHeight);
    for (int i = 0; i < [self.titleArray count]; i++)  {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//      UIImageView *imGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        btn.tag = i+10;
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [btn setTitleColor:BGBlue forState:UIControlStateSelected];

        if (i == 0) {
            btn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            btn.selected =YES;
            _seletedBtn = btn;
        } else {
            btn.selected = NO;
            
        }
        CGFloat width = ScreenWidth/self.titleArray.count;
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:Default_APP_Font_Regu size:18]};
        
        CGRect titleRect =  [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
        
//        CGFloat ScreenWidt = [[UIScreen mainScreen] bounds].size.width;
//        CGFloat jianJu = (ScreenWidt - titleWidth)/(self.titleArray.count +1);
//        ViewX = (ViewX + jianJu);
        ViewX = (ViewX + 0);

        btn.frame = CGRectMake(ViewX, 0,width,self.btnViewHeight);

//        imGView.frame = CGRectMake(ViewX +width+5, (self.btnViewHeight - 6)/2, 11, 6);
        if (i == 0) {
//            self.lineView.frame = CGRectMake(jianJu,self.btnViewHeight-self.btnLineHeight,width,self.btnLineHeight);
            self.lineView.frame = CGRectMake(0,self.btnViewHeight-self.btnLineHeight,titleRect.size.width,self.btnLineHeight);
            self.lineView.centerX = btn.centerX;

        }
         ViewX = width + ViewX;
        lastBtn = btn;
//        [_btnView addSubview:imGView];
        [_btnView addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *downLine = [UIView new];
    downLine.frame = CGRectMake(0,self.btnViewHeight-0.3,[[UIScreen mainScreen] bounds].size.width, 0.3);
    downLine.backgroundColor = [UIColor blackColor];
    downLine.alpha = 0.3;
    [_btnView addSubview:downLine];
    [_btnView addSubview:self.lineView];
    
}

- (void)CreatelineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BGBlue;
    }
}

- (void)scrollVc1 {
    for (int i = 0; i<3; i++) {
        UIViewController *vc = self.viewControllers[i];
        vc.view.frame = CGRectMake(i*[[UIScreen mainScreen] bounds].size.width,0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-94);
        [self.pageScroll addSubview:vc.view];
    }
}
- (void)changeItem:(NSNotification *)noti{
    
    NSDictionary *dic = [noti valueForKey:@"userInfo"];
    UIButton *sender = [dic objectForKey:@"sender"];
    [UIView animateWithDuration:0.1 animations:^{

        CGFloat x = CGRectGetMinX(sender.frame);
//        CGFloat width = CGRectGetWidth(sender.frame);
        
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:Default_APP_Font_Regu size:18]};
        
        CGRect titleRect =  [sender.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
        self.lineView.frame = CGRectMake(x,self.btnViewHeight-self.btnLineHeight, titleRect.size.width, self.btnLineHeight);
        self.lineView.centerX = sender.centerX;

    }];
    
    self.pageScroll.contentOffset = CGPointMake((sender.tag-10)*self.frame.size.width, 0);
    [self.pageScroll setContentOffset:CGPointMake((sender.tag-10)*self.frame.size.width, 0) animated:NO];
    _seletedBtn = sender;
    [self changeBtnColor:sender];
}

- (void)changeBtnColor:(UIButton*)btn{
    btn.titleLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
    UIButton *button1 = [self.btnView viewWithTag:10];
    UIButton *button2 = [self.btnView viewWithTag:11];
    UIButton *button3 = [self.btnView viewWithTag:12];
        switch (btn.tag) {
            case 10:
                button2.selected = NO;
                button3.selected = NO;
                [button2 setTitle:@"港澳台" forState:UIControlStateNormal];
                button2.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
                [[IQKeyboardManager sharedManager] setEnable:YES];
                [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

                break;
            case 11:
                button1.selected = NO;
                button3.selected = NO;
                [button1 setTitle:@"国内" forState:UIControlStateNormal];
                button1.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
                [[IQKeyboardManager sharedManager] setEnable:YES];
                [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

                break;
            case 12:
                button1.selected = NO;
                button2.selected = NO;
                [button2 setTitle:@"港澳台" forState:UIControlStateNormal];
                [button1 setTitle:@"国内" forState:UIControlStateNormal];
                button2.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
                [[IQKeyboardManager sharedManager] setEnable:YES];
                [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];


                break;
            default:
                break;
        }
    
}

//自己写的方法(按钮的点击方法/自己的方法)
- (void)btnClick:(UIButton *)sender {
    
    if (_ChooseItemClickBlock) {
        _ChooseItemClickBlock(sender);
    }

    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    index = scrollView.contentOffset.x/scrollView.frame.size.width;
    UIButton *btn = (UIButton *)[self.btnView viewWithTag:index+10];
    if (_seletedBtn != btn) {
        [UIView animateWithDuration:0.1 animations:^{
            [btn setTitleColor:BGBlue forState:UIControlStateNormal];
            [_seletedBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            CGFloat x = CGRectGetMinX(btn.frame);
//            CGFloat width = CGRectGetWidth(btn.frame);

            NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:Default_APP_Font_Regu size:18]};

          CGRect titleRect =  [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
            self.lineView.frame = CGRectMake(x,self.btnViewHeight-self.btnLineHeight, titleRect.size.width,self.btnLineHeight);
            self.lineView.centerX = btn.centerX;

        }];
        _seletedBtn = btn;
    }
}

@end
