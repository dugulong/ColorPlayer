//
//  PhotoViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14/11/11.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoViewController ()

@end

@implementation PhotoViewController

#define PRE_VIEW_TAG  90000
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setPhotoVCLayout];
}

-(void)setPhotoVCLayout{
    [self setControllLayOutWithFrame:CGRectMake(50,60,50, 30) Tag:5000 Title:@"行数:"];
    [self setControllLayOutWithFrame:CGRectMake(50,120,50, 30) Tag:6000 Title:@"列数:"];
}

-(void)setControllLayOutWithFrame:(CGRect)rect Tag:(int)tag Title:(NSString *)title {
    
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = title;
    [self.view addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+20,label.frame.origin.y,30, 30)];
    label.text = @"0";
    label.tag =tag ;
    [self.view addSubview:label];
    
    UIStepper  *stepper = [[UIStepper alloc]initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+20,label.frame.origin.y, 50, 30)];
    stepper.tag = tag+1;
    stepper.minimumValue = 0;
    stepper.maximumValue = 10;
    stepper.value = 0;
    [stepper addTarget:self action:@selector(doStepper:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:stepper];
}


-(void)doStepper:(UIStepper *)stepper{
    int x = 0;
    int y = 0;
    if (stepper.continuous) {
        NSLog(@"stepper:%d",(int)stepper.value);
        if (stepper.tag==5000) {
            x =(int)stepper.value;
        }else {
            y=(int)stepper.value;
        }
        UILabel *label = ( UILabel *)[self.view viewWithTag:stepper.tag-1];
        label.text = [NSString stringWithFormat:@"%d",(int)stepper.value];
    }
    
    [self setPreView:x Y:y];
}

-(void)setPreView:(int)x Y:(int)y{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *aView =[self.view viewWithTag:PRE_VIEW_TAG];
    if (aView ==nil) {
        aView = [[UIView alloc]initWithFrame:CGRectMake(10,150,250,250*size.height/size.width)];
        aView.tag = PRE_VIEW_TAG;
         aView.backgroundColor = [UIColor grayColor];
         [self.view addSubview:aView];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectt = CGRectMake(100 ,100, 100, 100);//坐标
    CGContextSetRGBFillColor(context, 61/ 255.0f, 122/ 255.0f, 160/ 255.0f,0.8);//颜色（RGB）,透明度
    CGContextFillRect(context, rectt);
}



//渐变
-(void)setGradientLayer:(UIView *)aView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = aView.bounds;
    [aView.layer addSublayer:gradientLayer];
    
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor ,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];
    
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);

}

- (UIImage*)buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType SuperView:(UIView *)aview{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(aview.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, aview.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(aview.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(aview.frame.size.width, aview.frame.size.height);
            break;
        case 3:
            start = CGPointMake(aview.frame.size.width, 0.0);
            end = CGPointMake(0.0, aview.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
     UIImage *image = [self buttonImageFromColors:[NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor],nil] ByGradientType:0 SuperView:aView];
     UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height)];
     imageView.image = image;
     [aView addSubview:imageView];
 }
 
 
 - (UIImage*)buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType SuperView:(UIView *)aview{
 NSMutableArray *ar = [NSMutableArray array];
 for(UIColor *c in colors) {
 [ar addObject:(id)c.CGColor];
 }
 UIGraphicsBeginImageContextWithOptions(aview.frame.size, YES, 1);
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSaveGState(context);
 CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
 CGPoint start;
 CGPoint end;
 switch (gradientType) {
 case 0:
 start = CGPointMake(0.0, 0.0);
 end = CGPointMake(0.0, aview.frame.size.height);
 break;
 case 1:
 start = CGPointMake(0.0, 0.0);
 end = CGPointMake(aview.frame.size.width, 0.0);
 break;
 case 2:
 start = CGPointMake(0.0, 0.0);
 end = CGPointMake(aview.frame.size.width, aview.frame.size.height);
 break;
 case 3:
 start = CGPointMake(aview.frame.size.width, 0.0);
 end = CGPointMake(0.0, aview.frame.size.height);
 break;
 default:
 break;
 }
 CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 CGGradientRelease(gradient);
 CGContextRestoreGState(context);
 CGColorSpaceRelease(colorSpace);
 UIGraphicsEndImageContext();
 return image;
 }
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
