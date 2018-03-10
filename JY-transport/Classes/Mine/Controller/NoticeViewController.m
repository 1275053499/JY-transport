//
//  NoticeViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"新消息通知";

    [self createTableView];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NoticeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoticeTableViewCell class]) owner:nil options:0][0];
     [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailLab.hidden = YES;
    cell.nameLabel.hidden = YES;
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"系统通知";
        cell.switchBtn.tag = 65;
        return cell;

    }else {
        
        cell.switchBtn.tag = 66;
        cell.textLabel.text = @"订单通知";
        cell.lineView.hidden = YES;


    return cell;
    }
    
    
}

- (void)switchAction:(UISwitch *)btn{
    
    switch (btn.tag) {
        case 65:
            if (btn.on) {
                
                [MBProgressHUD showInfoMessage:@"已开启系统通知"];
                
            }else{
                
            }
            break;
        case 66:
            if (btn.on) {
                
                [MBProgressHUD showInfoMessage:@"已开启订单通知"];
                
            }else{
                
            }
            break;
            
        default:
            break;
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
