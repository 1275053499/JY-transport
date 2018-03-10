//
//  AdBannerView.m
//  ERAPP
//
//  Created by PeterZhang on 15/12/8.
//  Copyright © 2015年 PeterZhang. All rights reserved.
//

#import "AdBannerView.h"

@interface AdBannerView()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,strong)UIImageView *rightImageVieww;
@property (nonatomic,assign)NSInteger imgCount;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)NSArray *imageInitArray;


@end

@implementation AdBannerView

- (void)initWithImage:(NSArray *)paraArray
{
    if(paraArray && ([paraArray count] >0))
    {
        _imageInitArray = paraArray;
        _currentIndex = 0;
        _imgCount = [_imageInitArray count];
        [self initSubviews];
    }
}

-(void)initSubviews
{
    
    int scrollViewWidth = 320 * HOR_SCALE;
    int scrollViewHeight =  70 * HOR_SCALE;
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake((self.bounds.size.width - scrollViewWidth)/2, 50,scrollViewWidth , scrollViewHeight)];
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate=self;
    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3,0);
    self.scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    [self addSubview:_scrollView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 200)/2, 0, 200, 50)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0,_scrollView.frame.size.width,_scrollView.frame.size.height)];
    _rightImageVieww = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width *2 , 0, _scrollView.frame.size.width,_scrollView.frame.size.height)];
    
    [self.scrollView addSubview:_leftImageView];
    [self.scrollView addSubview:_currentImageView];
    [self.scrollView addSubview:_rightImageVieww];
    [self creatButton];
    [self initImages];
}
- (void)creatButton{
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (_scrollView.frame.size.height - 44)/2 + 50, 44, 44)];
    [_leftButton setImage:[UIImage imageNamed:@"list_icon_back"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(liftButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_leftButton];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 5 - 44, (_scrollView.frame.size.height - 44)/2 + 50, 44, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"icon_jiantou2"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:_rightButton];
    
}
- (void)initImages{
    
    NSInteger a = (_currentIndex - 1 + _imgCount) % _imgCount;
    NSInteger b = (_currentIndex + 1) % _imgCount;
    _titleLabel.text = _carName[_currentIndex];
    _leftImageView.image = [UIImage imageNamed:_imageInitArray[a]];
    
    _currentImageView.image = [UIImage imageNamed:_imageInitArray[_currentIndex]];
    
    _rightImageVieww.image = [UIImage imageNamed:_imageInitArray[b]];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld", (long)_currentIndex] forKey:@"pageControlPage"];
    
    NSDictionary *dic =  @{@"pageControlPage":@(_currentIndex)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"carTypeChange" object:nil userInfo:dic];
    
}

#pragma -mark UIScrollViewDelegate  代理

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //    int a = round(scrollviewX/ScreenWidth);
    //    NSLog(@"====%d====",a);
    //    if (a == 0) {
    CGPoint contentOffset = [_scrollView contentOffset];
    
    if(contentOffset.x > _scrollView.frame.size.width){
        _currentIndex = ++_currentIndex % _imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width , 0)];
    }else if(contentOffset.x < _scrollView.frame.size.width ){
        _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width , 0)];
    }
    else{
        NSLog(@"do nothing");
    }
    
}





- (void)liftButtonClick
{
    
    _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
    [self initImages];
    
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width  *2,0)];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

-(void)rightButtonClick{
    _currentIndex =++ _currentIndex % _imgCount;
    [self initImages];
    
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width , 0) animated:YES];
    
}


@end

