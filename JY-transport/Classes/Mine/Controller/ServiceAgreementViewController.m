//
//  ServiceAgreementViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ServiceAgreementViewController.h"

@interface ServiceAgreementViewController ()

@end

@implementation ServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"服务协议";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, ScreenWidth - 3, ScreenHeight - 64)];
    textView.font = [UIFont systemFontOfSize:15.f];
    
    
    NSError *error = nil;
    NSString *txtpath = [[NSBundle mainBundle] pathForResource:@"serviceAgreement" ofType:@"txt"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:txtpath encoding:NSUTF8StringEncoding error:nil];
    
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"serviceAgreement" ofType:@"txt"]];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//    NSString *str = [[NSString alloc]initWithData:data encoding:enc];
    
    if (error)
    {
        NSLog(@"读取文件出错：%@", error);
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        
        textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
       
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    textView.editable = NO;
    textView.text = string;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
