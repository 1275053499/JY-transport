//
//  JYSendDescriptionViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYSendDescriptionViewController.h"
#import "UIImageView+WebCache.h"
#import "JYSendTableViewCell.h"
#import "JYSendPhotoTableViewCell.h"

#import "JYALAssetsLibrary.h"

@interface JYSendDescriptionViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)JYSendPhotoTableViewCell *PhotoCell;
@property (nonatomic,strong)UILabel *desLabel;
@property (nonatomic,strong)NSArray *selectImageArr;
@property (nonatomic,strong)NSString *text;//文本

@end

@implementation JYSendDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _selectImageArr = [NSArray array];
    _text = @"";

    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"保存" target:self action:@selector(saveImg)];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    [self creatTableView];


}
- (void)returnAction{
    
    NSArray *bigImgArr = [self getBigImageArray:_selectImageArr];
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"textOrder"];
    if (bigImgArr == nil || bigImgArr.count <= 0) {
        bigImgArr = [NSArray array];
    }if (text == nil || text.length<= 0) {
        text= @"";
    }
    
    
    NSDictionary *dic = @{@"bigImgArr":bigImgArr,
                          @"text":text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageAndContent" object:nil userInfo:dic];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImg{
    
    [[NSUserDefaults standardUserDefaults] setObject:_text forKey:@"textOrder"];

  
    NSArray *array =  [self getALAssetArray];
// ALAsset取asset.defaultRepresentation.url，存url。取出来之后再用assetForURL转回来。
    NSMutableArray *arr = [NSMutableArray array];

    for (ALAsset *set in array) {
        NSURL *url = set.defaultRepresentation.url;
        NSString *urlStr = url.absoluteString;
    
        [arr addObject:urlStr];
    }
    NSArray *PhotoUrl = [NSArray arrayWithArray:arr];
    [[NSUserDefaults standardUserDefaults] setObject:PhotoUrl forKey:@"imageOrder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getSavePhotos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"textOrder"];
    _text = text;

    [self getSavePhotos];
   
}
-(void)getSavePhotos{
    
    NSArray *imgArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageOrder"];
    if (imgArr== nil || imgArr.count == 0) {
        self.showInView = self.tableView;
        /** 初始化collectionView */
        [self initPickerView];
        [self updatePickerViewFrameY:200];
        
    }else{
        [self creatPhotoView:imgArr];
        
    }
}
- (void)creatPhotoView:(NSArray *)imgArr{
    
    NSMutableArray *arr = [NSMutableArray array];
    //单利获取lib。否则取到url为nil
    JYALAssetsLibrary *library = [JYALAssetsLibrary defaultAssetsLibrary];
    __weak __typeof(self) weakSelf = self;
    
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSURL *url = [NSURL URLWithString:obj];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [library assetForURL:url resultBlock:^(ALAsset *asset) {
                [arr addObject:asset];
                NSLog(@"%@===",arr);
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (idx == imgArr.count - 1) {
                        _selectImageArr = arr;

                        weakSelf.arrSelected = arr;
                        weakSelf.showInView = weakSelf.tableView;
                        /** 初始化collectionView */
                        [weakSelf initPickerView];
                        [weakSelf updatePickerViewFrameY:200];
                        
                    }
                    
                });
                
            } failureBlock:^(NSError *error) {
                
            }];
        });
        
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
        return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 180;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 9;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 0) {
        JYSendTableViewCell *cell = [JYSendTableViewCell cellWithTableView:tableView];
        cell.sendTextView.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
        cell.descLabel.text = @"写下你想说的话 （最多200字）";
        if (_text.length> 0) {
            
            cell.descLabel.text = @"";
        }
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.sendTextView.delegate = self;
        cell.sendTextView.text = _text;
        _desLabel = cell.descLabel;
        return cell;
//    }else{
//
//        JYSendPhotoTableViewCell *cell = [JYSendPhotoTableViewCell cellWithTableView:tableView];
//        cell.backgroundColor = BgColorOfUIView;
//        cell.imgBackView.backgroundColor = BgColorOfUIView;
//        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_desLabel setHidden:NO];
        
    }else{
        
        _text = textView.text;
        [_desLabel setHidden:YES];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
