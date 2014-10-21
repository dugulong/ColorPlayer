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

#import "StandardColorViewController.h"

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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100,size.height-100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonPress{
    StandardColorViewController *standardVC =[[StandardColorViewController alloc]init];
    [self presentViewController:standardVC animated:YES completion:nil];
}


-(void)setLayout{
    float height =palette.frame.size.height+palette.frame.origin.y;
    
    [self setMyLabel:CGRectMake(10, height+20,30, 30) text:@"R:"];
    [self setMyTestFeild:CGRectMake(50, height+20, 90, 30) Tag:10000];
    
    [self setMyLabel:CGRectMake(10, height+60,30, 30) text:@"G:"];
    [self setMyTestFeild:CGRectMake(50, height+60, 90, 30) Tag:11000];
    
    [self setMyLabel:CGRectMake(10, height+100,30, 30) text:@"B:"];
    [self setMyTestFeild:CGRectMake(50, height+100, 90, 30) Tag:12000];
    
    
    [self setMyLabel:CGRectMake(10, height+140,50, 30) text:@"hex16:"];
    [self setMyTestFeild:CGRectMake(50, height+140, 90, 30) Tag:13000];
    
    
    
    [self setMyLabel:CGRectMake(170, height+20,30, 30) text:@"H:"];
    [self setMyTestFeild:CGRectMake(210, height+20, 90, 30) Tag:20000];
    
    [self setMyLabel:CGRectMake(170, height+60,30, 30) text:@"S:"];
    [self setMyTestFeild:CGRectMake(210, height+60, 90, 30) Tag:21000];
    
    [self setMyLabel:CGRectMake(170, height+100,30, 30) text:@"B:"];
    [self setMyTestFeild:CGRectMake(210, height+100, 90, 30) Tag:22000];
    

}

-(void)setMyTestFeild:(CGRect)rect Tag:(int)tag{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor blueColor];
    textField.tag = tag;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
    [self resetTheColor:textField.tag];
    return NO;
}


-(void)resetTheColor:(int )tag{
    if (tag<20000) {
        UITextField *r_textField = (UITextField *)[self.view viewWithTag:10000];
        float r = [r_textField.text floatValue];
        
        UITextField *g_textField = (UITextField *)[self.view viewWithTag:11000];
        float g = [g_textField.text floatValue];
        
        UITextField *b_textField = (UITextField *)[self.view viewWithTag:12000];
        float b = [b_textField.text floatValue];
        
        self.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    }else{
        UITextField *h_textField = (UITextField *)[self.view viewWithTag:20000];
        float h = [h_textField.text floatValue];
        
        UITextField *s_textField = (UITextField *)[self.view viewWithTag:21000];
        float s = [s_textField.text floatValue];
        
        UITextField *b_textField = (UITextField *)[self.view viewWithTag:22000];
        float b = [b_textField.text floatValue];
        
        self.view.backgroundColor = [UIColor colorWithHue:h saturation:s brightness:b alpha:1.0];
    }
    
    [self changeColor:self.view.backgroundColor];
}

#pragma -mark PaletteDelegate

-(void)changeColor:(UIColor *)_color{
    self.view.backgroundColor = _color;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alph;
    
    [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:&alph];

    UITextField *r_textField = (UITextField *)[self.view viewWithTag:10000];
    r_textField.text = [NSString stringWithFormat:@"%0.1f",red*255];
    
    UITextField *g_textField = (UITextField *)[self.view viewWithTag:11000];
    g_textField.text = [NSString stringWithFormat:@"%0.1f",green*255];
    
    UITextField *b_textField = (UITextField *)[self.view viewWithTag:12000];
    b_textField.text = [NSString stringWithFormat:@"%0.1f",blue*255];
    
    UITextField *hex_textField = (UITextField *)[self.view viewWithTag:13000];
    hex_textField.text = [NSString stringWithFormat:@"%@",[ColorFactory turnRGBToHex16:red*255 G:green*255 B:blue*255]];
    
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alp;
    [self.view.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alp];
    
    UITextField *h_textField = (UITextField *)[self.view viewWithTag:20000];
    h_textField.text = [NSString stringWithFormat:@"%0.2f",hue];
    
    UITextField *s_textField = (UITextField *)[self.view viewWithTag:21000];
    s_textField.text = [NSString stringWithFormat:@"%0.2f",saturation];
    
    UITextField *bb_textField = (UITextField *)[self.view viewWithTag:22000];
    bb_textField.text = [NSString stringWithFormat:@"%0.2f",brightness];

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
