//
//  SetViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SetViewController.h"
#import "JYAccountTool.h"
#import "LoginViewController.h"
#import "SettingAboutOurViewController.h"
#import "SettingTableViewCell.h"
#import "NoticeViewController.h"
#import "SuggestionsViewController.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.view.backgroundColor = BgColorOfUIView;
    [self createTableView];
}
-(void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SettingTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SettingTableViewCell class]) owner:nil options:0][0];
   
    cell.statusLabel.text = @"";
   
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.statusLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.nameLabel.textColor = RGB(51, 51, 51);
    cell.accessoryImg.image = [UIImage imageNamed:@"icon_jiantou2"];
    if (indexPath.section == 0) {
    
            cell.nameLabel.text=@"新消息通知";
            
    }else if (indexPath.section == 1){
            
            cell.nameLabel.text=@"意见反馈";
            
    }else if (indexPath.section == 2){
            
            cell.accessoryView = nil;
            cell.nameLabel.text = @"关于简运";
            cell.lineView.hidden = YES;
            return cell;
        
    }else{
        
        cell.accessoryImg.hidden = YES;
        cell.logout.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        cell.logout.textColor = RGB(51, 51, 51);
        cell.logout.text = @"退出登录";
    }
   
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else if (section == 3) {
        return 50;
    }else{
        return 5;
        
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    contenView.backgroundColor = BgColorOfUIView;
    return contenView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        NoticeViewController *aboutOurVC = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:aboutOurVC animated:YES];
            
    }else if (indexPath.section == 1) {
            
        SuggestionsViewController *suggest = [[SuggestionsViewController alloc] init];
        [self.navigationController pushViewController:suggest animated:YES];
       
    }else if (indexPath.section == 2) {
        
        SettingAboutOurViewController *aboutOurVC = [[SettingAboutOurViewController alloc] init];
        [self.navigationController pushViewController:aboutOurVC animated:YES];
        
    }else if(indexPath.section == 3){
        
        [self TixianButtonClick];
    }
    
}



- (void)presentTipAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您要退出登录吗？" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [JYAccountTool deleteJYAccount];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[LoginViewController alloc]init];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    //点击按钮的响应事件
    
    [alert addAction:action];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:true completion:nil];
    
}


-(void)TixianButtonClick
{
    [self presentTipAlert];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
