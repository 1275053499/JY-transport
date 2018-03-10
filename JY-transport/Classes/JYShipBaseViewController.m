//
//  JYShipBaseViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYShipBaseViewController.h"
#import "JYSecondViewController.h"
#import "JYThirdViewController.h"
#import "DeliverGoodsViewController.h"
#import "MainView.h"
@interface JYShipBaseViewController ()
@property (nonatomic,retain) NSArray               *viewControllers;

@end

@implementation JYShipBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设定详情";
    self.view.backgroundColor = RGB(234, 239, 243);
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self createVc];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createVc {
    DeliverGoodsViewController   *firstVc  = [[DeliverGoodsViewController alloc] init];
    JYSecondViewController  *secondVc = [[JYSecondViewController alloc] init];
    JYThirdViewController   *ThirdVc  = [[JYThirdViewController alloc] init];
    [self addChildViewController:firstVc];
    [self addChildViewController:secondVc];
    [self addChildViewController:ThirdVc];
    self.viewControllers        = [NSArray arrayWithObjects:firstVc,secondVc,ThirdVc,nil];
    
    MainView *main = [[MainView alloc] init];
    
    main.ChooseItemClickBlock  = ^(UIButton *button){
        [firstVc chooseItem:button];
    } ;
    [self.view addSubview:main];
    main.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight-64);
    //设置菜单view 的高度
    main.btnViewHeight = 42;
    //设置按钮下划线高度
    main.btnLineHeight = 2;
    //设置按钮字体大小
    main.btnFont       = 18;
    main.viewControllers = self.viewControllers;
    NSArray *array  = @[@"专线",@"港澳台",@"同城急件"];
    main.titleArray = array;
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
