//
//  JYEditAddressTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYEditAddressTableViewCell.h"

@implementation JYEditAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFontColorAndSize{
    
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:@"手机号或固话" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18]}];
    self.phoneTextField.attributedPlaceholder = attrString;
    
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]initWithString:@"姓名" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18]}];
    self.nameTextField.attributedPlaceholder = nameString;
    
    NSAttributedString *addressString = [[NSAttributedString alloc]initWithString:@"收件人详细地址(详细到门牌)" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18]}];
    self.addressDetailTextField.attributedPlaceholder = addressString;
    
    NSAttributedString *addressDString = [[NSAttributedString alloc]initWithString:@"省 市 区" attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:18]}];
    self.addressTextField.attributedPlaceholder = addressDString;
    
    
    self.nameTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    self.phoneTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    self.addressDetailTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    self.addressTextField.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    
    
    
    self.nameTextField.textColor = RGB(51, 51, 51);
    self.phoneTextField.textColor = RGB(51, 51, 51);
    self.addressDetailTextField.textColor = RGB(51, 51, 51);
    self.addressTextField.textColor = RGB(51, 51, 51);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
