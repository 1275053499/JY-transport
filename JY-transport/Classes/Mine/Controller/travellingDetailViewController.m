//
//  travellingDetailViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "travellingDetailViewController.h"

@interface travellingDetailViewController ()

@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation travellingDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"路费详情";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self createTableView];
}
-(void)createTableView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];

    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_xiangqing"]];
    view.frame = CGRectMake(0, 0, ScreenWidth,1414 / 2 * HOR_SCALE);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 1414 / 2 * HOR_SCALE);
    
    [self.scrollView addSubview: view];
    [self.view addSubview: self.scrollView];
   
    
}

- (void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
