//
//  JYLookCompanyViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookCompanyViewController.h"
#import "JYLookCompanyTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface JYLookCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation JYLookCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}


-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 95)];
    [self.view addSubview:imgBackView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2, 34, 60, 60)];
    [imgBackView addSubview:imgView];
    if (_icon == nil || [_icon isEqual:[NSNull null]]) {
        _icon = @"";
    }
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_icon];
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];

    self.tableView.tableHeaderView = imgBackView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYLookCompanyTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYLookCompanyTableViewCell class]) owner:nil options:0][0];
    cell.contentLabel.numberOfLines = 0;
    cell.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (_introductions == nil || [_introductions isEqual:[NSNull null]]) {
        _introductions = @"";
    }
    cell.contentLabel.text = _introductions;
    return cell;
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
