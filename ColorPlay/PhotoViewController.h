//
//  PhotoViewController.h
//  ColorPlay
//
//  Created by long_zhang on 14/11/11.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;
@interface PhotoViewController : SuperViewController
@end
