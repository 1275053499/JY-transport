//
//  JYEditCompanyIconViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYEditCompanyIconViewController.h"
#import <Photos/Photos.h>
#import <QiniuSDK.h>

#import "UserInfoModel.h"
#import "MineRequestData.h"
#import <UIImageView+WebCache.h>

@interface JYEditCompanyIconViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MineRequestDataDelegate>

@property (nonatomic,strong) UIImageView *headImg;

@property (nonatomic,strong)UserInfoModel *userModel;
@end

@implementation JYEditCompanyIconViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    
    _headImg = [[UIImageView alloc] init];
    _headImg.frame = CGRectMake(0, (ScreenHeight - 64 - ScreenWidth)/2, ScreenWidth, ScreenWidth);
    [self.view addSubview:_headImg];
    
    _userModel = [[JYAccountTool shareInstance] getUserInfoModelInfo];
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_userModel.icon];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [self ChangeInfoImag];
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}



//调用相机或相册
- (void)ChangeInfoImag{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        cameraPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.delegate = self;
        photoPicker.allowsEditing = YES;
        photoPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:photoPicker animated:YES completion:nil];
    }];
    UIAlertAction *saveImgAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self loadImageFinished:_headImg.image];
        
    }];
   
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    
    [cameraAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [photoAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [saveImgAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];

    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [alert addAction:saveImgAction];
   
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"保存成功"];
            });
//            //成功后取相册中的图片对象
//            __block PHAsset *imageAsset = nil;
//            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
//            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                imageAsset = obj;
//                *stop = YES;
//            }];
//            if (imageAsset)
//            {
//                //加载图片数据
//                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
//                                                                  options:nil
//                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                                                                NSLog(@"imageData = %@", imageData);
//                                                            }];
//            }
        }
    }];
}
// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    NSLog(@"%@", info);
    _headImg.image = [info objectForKey:UIImagePickerControllerEditedImage];
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
    NSData *data = [NSData imageData:_headImg.image];

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
    }
}

- (void)requestDataInMineFailed:(NSError *)error{
    
    
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
