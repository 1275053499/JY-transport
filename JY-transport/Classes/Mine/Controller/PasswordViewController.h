//
//  PasswordViewController.h
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PassWordType)
{
    PassWordTypeChange = 1,
    PassWordTypeSetNew = 2,
};

@interface PasswordViewController : UIViewController

@property (nonatomic,assign)PassWordType passwordType;
@end
