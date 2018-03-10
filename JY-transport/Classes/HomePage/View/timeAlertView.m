//
//  timeAlertView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "timeAlertView.h"
#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20

@interface timeAlertView ()



@property (nonatomic,assign)int Numtime;
@property (nonatomic,assign)int numdriver;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *timeDriver;
@end
@implementation timeAlertView



- (void)setAnationView{
    
    _numdriver = 1;
    _Numtime = 0;
    
    if ([_timeOrDistance isEqualToString:@"distance"]) {
        self.distanceNum.text = _distanceStr;
    }else{

        [self addNstimert];
    }
}

- (void)addNstimert{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatTime) userInfo:nil repeats:YES];
    
    _timeDriver = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(repeatDriverNum) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:_timeDriver forMode:NSRunLoopCommonModes];
    
}

- (void)repeatTime{
    int seconds = _Numtime % 60;
    int minutes = (_Numtime / 60) % 60;
    int hours = _Numtime / 3600;
    _Numtime++;
    self.timeNum.text =  [NSString stringWithFormat:@"已用时%02d:%02d:%02d",hours, minutes, seconds];
    
}

- (void)repeatDriverNum{
    
    self.driverNum.text = [NSString stringWithFormat:@"已通知%d个司机",_numdriver++];;
    
}
- (void)dealloc{
    [self.timer invalidate];
    [self.timeDriver invalidate];
    self.timeDriver = nil;
    self.timer = nil;
}
@end
