//
//  SettingAboutOurViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SettingAboutOurViewController.h"
#import "ServiceAgreementViewController.h"
#import "SuggestionsViewController.h"
#import "SettingTableViewCell.h"
@interface SettingAboutOurViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation SettingAboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"关于简运";
    
    [self creatTableView];
    
}
- (void)creatTableView{
    
    UIView *topBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    topBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBottomView];
    
    UIImage *img = [UIImage imageNamed:@"icon_logo"];
    UIImageView *imgView= [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake((ScreenWidth - 80)/2,30 , 80,80);
    [topBottomView addSubview:imgView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 120, 100, 45)];
    NSString *version = [NSString stringWithFormat:@"简运 V %@",appCurVersion];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = version;
    [topBottomView addSubview:lab];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200 + 9, ScreenWidth, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = BgColorOfUIView;
    _tableView.rowHeight = 50;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SettingTableViewCell class]) owner:nil options:0][0];
    
    cell.statusLabel.text = @"";
    
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.statusLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.accessoryImg.image = [UIImage imageNamed:@"icon_jiantou2"];
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"去评分";
    }else if (indexPath.row == 1){
        
        cell.nameLabel.text = @"服务协议";
        
    }else{
        cell.nameLabel.text = @"公司简介";
        cell.lineView.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        [self goToScore];
    }
    if (indexPath.row == 1) {
        ServiceAgreementViewController *serVC = [[ServiceAgreementViewController alloc] init];
        [self.navigationController pushViewController:serVC animated:YES];
    }
    
}

- (void)goToScore{
    NSString *appid = @"1333380514";
    
   
    if (  [[UIDevice currentDevice].systemVersion doubleValue] >= 11.0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/twitter/id1333380514?mt=8&action=write-review"]];
        
    }else{
        
        NSString *scoreStr = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appid];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:scoreStr]];
        
        
    }
    
}
@end
