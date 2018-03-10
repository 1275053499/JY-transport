//
//  OrderMapAddressTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderMapAddressTableViewCell.h"
#import "OrderModel.h"
@interface OrderMapAddressTableViewCell ()

@property (nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property (nonatomic,strong)NSMutableArray *arrivePlaceArray;
@end
@implementation OrderMapAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(OrderModel *)model{
    
    _model = model;
    self.arrivePlaceArray = [NSMutableArray array];
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arrivePlaceArray = [model.arrivePlace componentsSeparatedByString:@","];
    NSArray *arrivePlaceAddressArray = [model.district componentsSeparatedByString:@","];
    [self.arrivePlaceArray addObjectsFromArray:arrivePlaceArray];
    [self.arrivePlaceAddressArray addObjectsFromArray:arrivePlaceAddressArray];
    
    if ([model.arrivePlace  rangeOfString:@","].location != NSNotFound) {
        
        [self.arrivePlaceArray removeLastObject];
        [self.arrivePlaceAddressArray removeLastObject];
    }else{
        
    }
    self.startLabel.text = model.departPlace;
    self.startSubLabel.text = model.city;
    
    
    self.endLabel.text = self.arrivePlaceArray.lastObject;
    self.endSubLabel.text = self.arrivePlaceAddressArray.lastObject;
    

}
@end
