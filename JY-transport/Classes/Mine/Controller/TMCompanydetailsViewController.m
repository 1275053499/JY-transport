//
//  TMCompanydetailsViewController.m
//  JY-transport
//
//  Created by 闫振 on 2018/2/5.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMCompanydetailsViewController.h"

@interface TMCompanydetailsViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *leftbuyCarView;
@property (nonatomic,strong)UIImageView *currentbuyCarView;
@property (nonatomic,strong)UIImageView *rightbuyCarView;
@property (nonatomic,assign)NSInteger imgCount;

@end

@implementation TMCompanydetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
     _array = @[@"activity_img_welfare",@"activity_img_shipping",@"activity_img_new",@"coupons_bg_highlight"];
    _imgCount = _array.count;
    _currentIndex = 0;
    [self creatScrollView];
}


- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth,150);
    self.scrollView.backgroundColor = BgColorOfUIView;
    _scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3,0);
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    [self.view addSubview:self.scrollView];
    
 

    
    
    CGFloat height = _scrollView.frame.size.height;
    _leftbuyCarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    _currentbuyCarView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0,ScreenWidth,height)];
    
    _rightbuyCarView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth *2 , 0, ScreenWidth,height)];
    
    [self.scrollView addSubview:_leftbuyCarView];
    [self.scrollView addSubview:_currentbuyCarView];
    [self.scrollView addSubview:_rightbuyCarView];
    [self initImages];
}


- (void)leftBtnClick:(UIButton *)btn{
    
    if (btn.tag == 3018) {
        _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
        [self initImages];
        
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth  *2,0)];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }else if(btn.tag == 3019){
        
        _currentIndex =++ _currentIndex % _imgCount;
        [self initImages];
        
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0) animated:YES];
        
    }
    
}
- (void)initImages{
    
    NSInteger a = (_currentIndex - 1 + _imgCount) % _imgCount;
    NSInteger b = (_currentIndex + 1) % _imgCount;
    _leftbuyCarView.image = [UIImage imageNamed:_array[a]];
    
//    _pageLabel.text = [NSString stringWithFormat:@"%ld/5",(long)_currentIndex + 1];
    _currentbuyCarView.image = [UIImage imageNamed:_array[_currentIndex]];
    
    _rightbuyCarView.image = [UIImage imageNamed:_array[b]];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
 
    
    CGPoint contentOffset = [_scrollView contentOffset];
    
    if(contentOffset.x > ScreenWidth){
        _currentIndex = ++_currentIndex % _imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0)];
    }
    else if(contentOffset.x < ScreenWidth ){
        _currentIndex = (_currentIndex-1+_imgCount)%_imgCount;
        [self initImages];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth , 0)];
    }
    else{
        NSLog(@"do nothing");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
