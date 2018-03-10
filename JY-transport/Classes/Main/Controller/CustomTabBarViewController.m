//
//  CustomTabBarViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CustomNavigationViewController.h"
#import "CustomButton.h"
#import "HomePageViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "JYMessageViewController.h"
#import "JYWaitingAnimationViewController.h"
#import "JYFavorableViewController.h"
@interface CustomTabBarViewController ()
{
    UIImageView *tabBarBackImageView; //自定义的覆盖原先的tarbar的控件
    CustomButton *previousBtn; //记录前一次选中的按钮
    NSArray *tabBarItemArray;
}

@property (nonatomic,strong)UINavigationController *messageNavigationController2;
@end

@implementation CustomTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createViewControllers];
    //    self.tabBar.hidden = YES;//隐藏原先的tabBar
    //    CGFloat tabBarViewY = ScreenHeight -49;
    tabBarBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    tabBarBackImageView.userInteractionEnabled = YES;
    //tabBarBackImageView.image = [UIImage imageNamed:@"background.png"];
    //    [self.view addSubview:tabBarBackImageView];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.tabBar addSubview:tabBarBackImageView];
    
    if (!tabBarItemArray)
    {
        tabBarItemArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:K_TAB_BAR_ITEM_ARRAY_FILE_NAME ofType:@""]];
    }
    
    // 下面的方法是调用自定义的生成按钮的方法
    for(NSInteger i=0;i<[tabBarItemArray count];i++)
    {
        NSDictionary *itemDic = [tabBarItemArray objectAtIndex:i];
        [self creatButtonWithNormalImageName:[itemDic valueForKey:K_TAB_BAR_ITEM_DEFAULT_IMAGE]  andHilightImageName:[itemDic valueForKey:K_TAB_BAR_ITEM_DEFAULT_HEIGHTLIGHT_IMAGE] andTitle:[itemDic valueForKey:K_TAB_BAR_ITEM_DEFAULT_TEXT] andIndex:i];
    }
    CustomButton *btn = tabBarBackImageView.subviews[0];
    [self changeViewController:btn]; //自定义的控件中的按钮被点击了调用的方法，默认进入界面就选中第一个按钮
    
    //注册一个通知，司机估价完成的提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrder:) name:@"newOrder_EvulteFinish" object:nil];}

- (void)createViewControllers
{
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    CustomNavigationViewController *homePageNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:homePageViewController];
    homePageNavigationController.delegate = self;
    
    MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    CustomNavigationViewController *messageNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:messageViewController];
    messageNavigationController.delegate = self;
    
    JYFavorableViewController *favorableViewController = [[JYFavorableViewController alloc] init];
    
    CustomNavigationViewController *favorableNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:favorableViewController];
    favorableNavigationController.delegate = self;
    
    MineViewController *mineViewController = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    CustomNavigationViewController *mineNavigationController = [[CustomNavigationViewController alloc] initWithRootViewController:mineViewController];
    mineNavigationController.delegate = self;
    
    
  
    self.viewControllers = [NSArray arrayWithObjects:homePageNavigationController,messageNavigationController,favorableNavigationController,mineNavigationController, nil];
}

#pragma mark 创建一个按钮
- (void)creatButtonWithNormalImageName:(NSString *)normal andHilightImageName:(NSString *)selected andTitle:(NSString *)title andIndex:(NSInteger)index
{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    
    CGFloat buttonWidth = tabBarBackImageView.frame.size.width / 4;
    CGFloat buttonHight = tabBarBackImageView.frame.size.height;
    button.frame = CGRectMake(buttonWidth *index,0, buttonWidth, buttonHight);
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(196, 196, 196)forState:UIControlStateNormal];
    [button setTitleColor:BGBlue forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    button.imageView.contentMode = UIViewContentModeCenter; // 让图片在按钮内居中
    button.titleLabel.textAlignment = NSTextAlignmentCenter; // 让标题在按钮内居中
    button.titleLabel.font = [UIFont systemFontOfSize:12]; // 设置标题的字体大小
    [tabBarBackImageView addSubview:button];
}

#pragma mark 按钮被点击时调用
- (void)changeViewController:(CustomButton *)sender
{
    
    self.selectedIndex = sender.tag;
    
    sender.selected = YES;
    if (previousBtn != sender)
    {
        previousBtn.selected = NO;
        
    }
//    if (sender.tag == 1) {
//
//        [self creatMessageView:sender.tag];
//        sender.selected = YES;

//}
    previousBtn = sender;
   
}
- (void)creatMessageView:(NSInteger)tag{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"发货订单" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UINavigationController *navi =  [self.viewControllers objectAtIndex:1];
        for (UIViewController *vc in navi.viewControllers) {
            [vc removeFromParentViewController];
        }
        
        JYMessageViewController *messageViewController = [[JYMessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        NSArray *arr = [NSArray arrayWithObjects:messageViewController, nil];
        [navi setViewControllers:arr animated:YES];

        
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"找车订单" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UINavigationController *navi =  [self.viewControllers objectAtIndex:1];
        for (UIViewController *vc in navi.viewControllers) {
            [vc removeFromParentViewController];
        }
        
        MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        NSArray *arr = [NSArray arrayWithObjects:messageViewController, nil];
        [navi setViewControllers:arr animated:YES];

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [firstAction setValue:BGBlue forKey:@"_titleTextColor"];
    [secondAction setValue:BGBlue forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(228, 122, 109, 1) forKey:@"_titleTextColor"];
    
    [alert addAction:secondAction];
    [alert addAction:firstAction];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)newOrder:(NSNotification *)notification{
    
    
  id  vc =  [self presentingVC];
    if ([vc isKindOfClass:[JYWaitingAnimationViewController class]]) {
        
    }else{
        [self presentTipForNewOrder];
 
    }
    
}

//获取到当前所在的视图
- (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[CustomTabBarViewController class]]) {
        result = [(CustomTabBarViewController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
- (void)presentTipForNewOrder{
    
    NSString *message = @"物流公司已出价，点开订单详情查看吧";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" " message:message preferredStyle: UIAlertControllerStyleAlert];
    
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Regu size:17] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:cancelaction];
    [alert addAction:sureaction];
    
    
    [self presentViewController:alert animated:true completion:nil];
}
/*
 #pragma mark -UINavigationControllerDelegate
 - (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
 {
 __weak typeof(tabBarBackImageView) weakTabBarImageView = tabBarBackImageView;
 CGRect tabBarFrame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
 if(viewController.hidesBottomBarWhenPushed)
 {
 [UIView animateWithDuration:0.24 animations:^{
 [weakTabBarImageView setHidden:YES];
 [weakTabBarImageView setFrame:tabBarFrame];
 }];
 }
 else
 {
 [UIView animateWithDuration:0.24 animations:^{
 [weakTabBarImageView setHidden:NO];
 [weakTabBarImageView setFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
 }];
 }
 }
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
