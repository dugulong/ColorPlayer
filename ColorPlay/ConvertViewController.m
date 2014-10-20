//
//  ConvertViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "ConvertViewController.h"
#import "ColorFactory.h"
#import "Palette.h"

@interface ConvertViewController ()<PaletteDelegate>
{
    UIImageView *_imageView;
    
    UIView *_aView;
    Palette  *palette;
}
@end

@implementation ConvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor grayColor];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    palette = [[Palette alloc]initWithFrame:CGRectMake((size.width-240)/2,40,240,240)];
    palette.paletteDelegate =self;
    [self.view addSubview:palette];
}



-(void)changeColor:(UIColor *)_color{
    self.view.backgroundColor = _color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
