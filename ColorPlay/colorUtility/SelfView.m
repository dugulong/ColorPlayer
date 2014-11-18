//
//  SelfView.m
//  ColorPlay
//
//  Created by long_zhang on 14/11/11.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "SelfView.h"

@implementation SelfView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 61/ 255.0f, 122/ 255.0f, 160/ 255.0f,0.8);//颜色（RGB）,透明度
    CGContextFillRect(context, rect);
}


@end
