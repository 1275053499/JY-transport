//
//  EditPersonalInfoVC.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EditPersonalInfoVC.h"
#import "EditorPersonTabCell.h"
#import "EditorTableViewCell.h"
#import "EditPersonalSexView.h"
#import "UIImage+YHLImage.h"
#import "EditPersonalNameVC.h"
#import "UserInfoModel.h"
#import <QiniuSDK.h>
#import "MineRequestData.h"
#import <UIImageView+WebCache.h>
#import "JYEditCompanyIconViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface EditPersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,QYChangeLabelValue,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditorPersonNameVCDelegate,MineRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)NSString *sexStr;
@property (nonatomic,strong)UIImage *headImg;
@property (nonatomic,strong)UserInfoModel *userModel;
@property (nonatomic,strong)UIImage *heardImg;
@end

@implementation EditPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    [self creatTableView];
    self.arr = @[@"保密",@"男",@"女"];
    _sexStr = @"保密";
    self.title = @"个人信息";
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
   

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    [_tableView reloadData];
}

//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
- (void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BgColorOfUIView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 86;
    }else{
        return 50;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 9;

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        EditorPersonTabCell *cell = [EditorPersonTabCell cellWithTableView:tableView];
        UIImageView *accessimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];
        cell.accessoryView = accessimg;
        cell.titleLabel.text = @"头像";
        cell.titleLabel.textColor = RGB(51, 51, 51);
        cell.headIcon.layer.cornerRadius = 33;
        cell.headIcon.layer.masksToBounds = YES;
   
        NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_userModel.icon];
        [cell.headIcon sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        return cell;
    }else {
    
        EditorTableViewCell *cell = [EditorTableViewCell cellWithTableView:tableView];
        cell.lineVIew.hidden = YES;
        cell.contenLabel.textColor = RGB(153, 153, 153);
        cell.nameLabel.textColor = RGB(51, 51, 51);
        cell.accessImgView.image = [UIImage imageNamed:@"icon_jiantou2"];
        cell.accessImgView.hidden = YES;
    
    if (indexPath.row == 0) {
        cell.accessImgView.hidden = NO;
        cell.lineVIew.hidden = NO;

        if (_userModel.nickname == nil || [_userModel.nickname isEqual:[NSNull null]]) {
            _userModel.nickname = userPhone;
        }
        cell.contenLabel.text = _userModel.nickname;
        cell.nameLabel.text = @"名字";
    }else if (indexPath.row == 1){
        cell.lineVIew.hidden = NO;

        cell.accessImgView.hidden = NO;

        if (_userModel.sexuality == nil || [_userModel.sexuality isEqual:[NSNull null]]) {
            cell.contenLabel.text = @"保密";
        }else{
            if ([_userModel.sexuality intValue]== 0) {
                cell.contenLabel.text = @"女";
            }else if ([_userModel.sexuality intValue] == 1 ){
                cell.contenLabel.text = @"男";
            }else{
                cell.contenLabel.text = @"保密";
            }
            
        }

        cell.nameLabel.text = @"性别";

    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contenLabel.text = userPhone;
        cell.nameLabel.text = @"手机号码";

    }
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self ChangeInfoImag];
        
//        JYEditCompanyIconViewController *vc = [[JYEditCompanyIconViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        if (indexPath.row == 0) {
            
            EditPersonalNameVC *nameVC = [[EditPersonalNameVC alloc] init];
            nameVC.delegate = self;
        nameVC.nickName= _userModel.nickname;
        [self.navigationController pushViewController:nameVC animated:YES];
            
    }else if (indexPath.row == 1) {
        
        EditPersonalSexView *sexView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EditPersonalSexView class]) owner:self options:nil][0];
        sexView.sexHeadLabel.text = @"性别";
        sexView.delegate = self;
        sexView.dataArr = self.arr;
        [sexView showSexView];
    }
        
    }
}

#pragma mark =============== 性别delegate ===============
- (void)changeLabelValue:(NSString *)value{
    _sexStr = value;
    if ([_sexStr isEqualToString:@"女"]) {
        [self queryDriverInfo:@"sexuality" :@"0"];
    }else if ([_sexStr isEqualToString:@"男"]){
        [self queryDriverInfo:@"sexuality" :@"1"];
        
    }else if ([_sexStr isEqualToString:@"保密"]){
        [self queryDriverInfo:@"sexuality" :@"2"];
    }
    
}


#pragma mark ============== delegate ===============
- (void)changeNameValue:(NSString *)value{
    
    if (value != nil || value.length > 0) {
        
        [self queryDriverInfo:@"nickname" :value];
    }

}

- (void)queryDriverInfo:(NSString*)tpye :(NSString*)str{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/updateUserInfo"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":_userModel.id,tpye:str} success:^(id responseObj) {
        //        NSArray *arr =[NSArray arrayWithObject:responseObj];
        NSString *statu =  [responseObj objectForKey:@"message"];
        if ([statu isEqualToString:@"0"]) {
          
            
            if ([tpye isEqualToString:@"nickname"]) {
                
               _userModel.nickname = str;
            }if ([tpye isEqualToString:@"sexuality"]) {
                
                _userModel.sexuality = str;
            }
            
            [[JYAccountTool shareInstance] saveUserInfoModel:_userModel];
            
            [_tableView reloadData];
        
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

//调用相机或相册
- (void)ChangeInfoImag{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            //没有权限
            [self presentTipAlertAuthStatus:@"请在iPhone的\"设置-隐私-相机\"选项中，允许简运访问你的手机相机"];
        }else{
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        cameraPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
        
        }
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author ==ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限 引导去开启
            [self presentTipAlertAuthStatus:@"请在iPhone的\"设置-隐私-照片\"选项中，允许简运访问你的手机相册"];
            
        }else{
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.delegate = self;
        photoPicker.allowsEditing = YES;
        photoPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:photoPicker animated:YES completion:nil];
        }
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    
    [cameraAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [photoAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)presentTipAlertAuthStatus:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    //点击按钮的响应事件
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}
// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    NSLog(@"%@", info);
    _heardImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [self getUpVoucher];
}


//从服务器获取上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        [self updateheadimage:voucher];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
    
}
//上传图片到七牛
- (void)updateheadimage:(NSString *)str{
    //
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    NSString * token = str;
    NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
    NSString *key = [NSString stringWithFormat:@"LogisticsIcon%@%@.png",_userModel.phone,keyStr];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_heardImg];
    
    [MBProgressHUD showInfoMessage:@"正在上传头像"];
    
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        [MBProgressHUD showSuccess:@"更换头像成功"];
        
        MineRequestData *manager = [[MineRequestData alloc] init];
        manager.delegate = self;
        _userModel.icon = key;
        [[JYAccountTool shareInstance] saveUserInfoModel:_userModel];
        //把七牛云的图片名称 上传到服务器
        [manager requsetDataId:_userModel.id icon:key];
        
    } option:nil];
    
}

//把七牛云的图片名称 上传到服务器
- (void)requestDataInMineSuccess:(NSDictionary *)resultDic{
    NSString *mess = [resultDic objectForKey:@"message"];
    if ([mess isEqualToString:@"0"] || mess == 0) {
        NSLog(@"上传图片名字成功");
        _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
        [self.tableView reloadData];
    }
}

- (void)requestDataInMineFailed:(NSError *)error{
    
    
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
