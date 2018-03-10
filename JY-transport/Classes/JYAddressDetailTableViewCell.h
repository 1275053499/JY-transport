//
//  JYAddressDetailTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAddressDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconType;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookAddressBtn;

- (void)setTextFieldColorAndFont;
@end
