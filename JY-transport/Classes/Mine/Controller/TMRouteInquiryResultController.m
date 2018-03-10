//
//  TMRouteInquiryResultController.m
//  JY-transport
//
//  Created by 闫振 on 2018/2/2.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMRouteInquiryResultController.h"
#import "MyLogisticsTableViewCell.h"


#import "JYLookOutletsViewController.h"
#import "JYLookCompanyViewController.h"

#import "JYLookEvaluateViewController.h"
#import "LoginticModel.h"
@interface TMRouteInquiryResultController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *logisticesArr;
@property (nonatomic,assign)NSInteger page;
@end

static NSString *TMRouteCell = @"TMRouteInquiryTableViewCell";

@implementation TMRouteInquiryResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线路直达";
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    _logisticesArr = [NSMutableArray array];
    _page = 1;
    [self creatHeadView];
    [self createTableView];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout=UIRectEdgeBottom;

    
}
- (void)creatHeadView{
    CGFloat spaceW = (ScreenWidth - 54 - 150 *2)/4;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150-64)];
    
    headView.backgroundColor = BGBlue;
    [self.view addSubview:headView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 40)];
    imgView.center = headView.center;
    imgView.image = [UIImage imageNamed:@"img_chaxun_baise"];
    [headView addSubview:imgView];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceW,(headView.frame.size.height-25)/2 , 150, 25)];
    startLabel.text = _startStr;

    startLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    startLabel.textColor = [UIColor whiteColor];
    startLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:startLabel];
    
    UILabel *endlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 150 - spaceW, (headView.frame.size.height-25)/2, 150, 25)];
    endlabel.textAlignment = NSTextAlignmentCenter;
    endlabel.text = _endStr;
    endlabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    endlabel.textColor = [UIColor whiteColor];
    
    [headView addSubview:endlabel];
    
   
    
}

- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setShadowImage:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,150-64, ScreenWidth, ScreenHeight - 150) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return 1;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 110;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        MyLogisticsTableViewCell *cell = [MyLogisticsTableViewCell cellWithTableView:tableView];
        cell.comModel = self.dataArr[indexPath.section];

        [cell.evaluationBtn addTarget:self action:@selector(lookEvaluationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.IntroductionBtn addTarget:self action:@selector(lookCompanyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.outletsBtn addTarget:self action:@selector(lookOutletsBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.evaluationBtn.tag = 66 + indexPath.section;
        cell.IntroductionBtn.tag = 67 + indexPath.section;
        cell.outletsBtn.tag = 68 + indexPath.section;
        return cell;
  

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
   
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)lookEvaluationBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.dataArr[btn.tag - 66];
    
    JYLookEvaluateViewController *vc = [[JYLookEvaluateViewController  alloc] init];
    vc.logisticsId = companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)lookCompanyBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.dataArr[btn.tag - 67];
    
    JYLookCompanyViewController *vc = [[JYLookCompanyViewController alloc] init];
    vc.introductions = companymodel.introductions;
    vc.icon = companymodel.icon;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lookOutletsBtnClick:(UIButton *)btn{
    JYCompanyModel *companymodel = self.dataArr[btn.tag - 68];
    
    JYLookOutletsViewController *vc = [[JYLookOutletsViewController alloc] init];
    vc.logisticsid = companymodel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)postSuccess:(id)red{
//    if (_page == 1) {
//
//        self.logisticesArr = [LoginticModel mj_objectArrayWithKeyValuesArray:resultDic];
//
//    }else{
//
//        NSMutableArray *dataArr = [NSMutableArray array];
//        dataArr = [LoginticModel mj_objectArrayWithKeyValuesArray:resultDic];
//        [self.logisticesArr  addObjectsFromArray:dataArr];
//
//        if (dataArr.count < 10) {
//
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//
//            [self.tableView.mj_footer endRefreshing];
//
//        }
//
//    }
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
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
