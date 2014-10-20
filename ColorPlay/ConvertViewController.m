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

@interface ConvertViewController ()<PaletteDelegate,UITextFieldDelegate>
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
    
    [self setLayout];
}

-(void)setLayout{
    float height =palette.frame.size.height+palette.frame.origin.y;
    
    [self setMyLabel:CGRectMake(20, height+20,30, 30) text:@"R:"];
    [self setMyTestFeild:CGRectMake(60, height+20, 100, 30) Tag:10000];
    
    [self setMyLabel:CGRectMake(20, height+60,30, 30) text:@"G:"];
    [self setMyTestFeild:CGRectMake(60, height+60, 100, 30) Tag:11000];
    
    [self setMyLabel:CGRectMake(20, height+100,30, 30) text:@"B:"];
    [self setMyTestFeild:CGRectMake(60, height+100, 100, 30) Tag:12000];
    
    
    [self setMyLabel:CGRectMake(20, height+140,50, 30) text:@"hex16:"];
    [self setMyTestFeild:CGRectMake(60, height+140, 100, 30) Tag:13000];
}

-(void)setMyTestFeild:(CGRect)rect Tag:(int)tag{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor blueColor];
    textField.tag = tag;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
}

-(void)setMyLabel:(CGRect)rect text:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = text;
    label.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self resetTheColor];
    return NO;
}


-(void)resetTheColor{
    UITextField *r_textField = (UITextField *)[self.view viewWithTag:10000];
    float r = [r_textField.text floatValue];
    
    UITextField *g_textField = (UITextField *)[self.view viewWithTag:11000];
    float g = [g_textField.text floatValue];
    
    UITextField *b_textField = (UITextField *)[self.view viewWithTag:12000];
    float b = [b_textField.text floatValue];
    
    self.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}



-(void)changeColor:(UIColor *)_color{
    self.view.backgroundColor = _color;
}

-(void)getColorRGB:(int)R G:(int)g B:(int)b alpha:(int)alpha{
    UITextField *r_textField = (UITextField *)[self.view viewWithTag:10000];
    r_textField.text = [NSString stringWithFormat:@"%d",R];
    
    UITextField *g_textField = (UITextField *)[self.view viewWithTag:11000];
    g_textField.text = [NSString stringWithFormat:@"%d",g];
    
    UITextField *b_textField = (UITextField *)[self.view viewWithTag:12000];
    b_textField.text = [NSString stringWithFormat:@"%d",b];
    
    UITextField *hex_textField = (UITextField *)[self.view viewWithTag:13000];
    hex_textField.text = [NSString stringWithFormat:@"%@",[ColorFactory turnRGBToHex16:R G:g B:b]];
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
