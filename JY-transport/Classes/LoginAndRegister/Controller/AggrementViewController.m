//
//  AggrementViewController.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "AggrementViewController.h"

@interface AggrementViewController ()

@end

@implementation AggrementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"服务协议";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, ScreenWidth - 3, ScreenHeight - 64)];
    textView.font = [UIFont systemFontOfSize:15.f];
    
    
    NSError *error = nil;
    NSString *txtpath = [[NSBundle mainBundle] pathForResource:@"aggrement" ofType:@"text"];
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

- (void)returnAction{
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
