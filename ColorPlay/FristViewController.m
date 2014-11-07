//
//  FristViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-21.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "FristViewController.h"

@implementation FristViewController
{
    int _currentNumber;
}
#define  MARGIN  20

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self resetLayout];
}

-(void)resetLayout{
    UIView *displayView =[self.view viewWithTag:3000];
    if (displayView !=nil) {
        [displayView removeFromSuperview];
    }
    displayView =[[UIView alloc]initWithFrame:CGRectMake(20, 100, 280, 280)];
    displayView.tag = 3000;
    [self setLayout:4 view:displayView];
    [self.view addSubview:displayView];
}

-(void)setLayout:(int)number view:(UIView *)view{
    _currentNumber= arc4random() % (number*number);
    int r_arc =  (arc4random() % 100) +155;
    int g_arc =  (arc4random() % 100) +155;
    int b_arc =  (arc4random() % 100) +155;

    
    UIColor *color = [UIColor colorWithRed:(float)r_arc/255 green:(float)g_arc/255 blue:(float)b_arc/255  alpha:1.0];
    UIColor *color1 = [UIColor colorWithRed:(float)(r_arc+15)/255 green:(float)g_arc/255 blue:(float)b_arc/255  alpha:1.0];
    
    for (int i=0; i<number; i++) {
        for (int j=0; j<number; j++) {
            float width = view.frame.size.width/number;
            float height = view.frame.size.height/number;
            UIView *aview= [[UIView alloc]initWithFrame:CGRectMake((width+1)*i, (height+1)*j, width, height)];
            aview.tag = 100+i+j*number;
            if (aview.tag-100==_currentNumber) {
                aview.backgroundColor = color1;
            }else{
                aview.backgroundColor = color;
            }
            UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesturePress:)];
            [aview addGestureRecognizer:gest];
            [view addSubview:aview];
        }
    }
}

-(void)gesturePress:(UITapGestureRecognizer *)gest{
//    NSLog(@"gest:%d,%d",gest.view.tag,_currentNumber);
    if (_currentNumber ==gest.view.tag-100) {
        [self resetLayout];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:@"you are loser!" delegate:self cancelButtonTitle:@"再来一次" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
    }
}
@end
