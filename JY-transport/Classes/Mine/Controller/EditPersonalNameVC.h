//
//  EditPersonalNameVC.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditorPersonNameVCDelegate <NSObject>

-(void)changeNameValue:(NSString *)value;

@end
@interface EditPersonalNameVC : UIViewController
@property (nonatomic,strong)id <EditorPersonNameVCDelegate> delegate;
@property (nonatomic,strong)NSString *nickName;

@end
