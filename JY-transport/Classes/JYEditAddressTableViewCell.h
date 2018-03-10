//
//  JYEditAddressTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYEditAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailTextField;
- (void)setFontColorAndSize;
@end
