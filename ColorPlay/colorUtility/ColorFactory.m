//
//  ColorFactory.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "ColorFactory.h"

@implementation ColorFactory


int RGB(int r,int g,int b)
{
    return r << 16 | g << 8 | b;
}

+(NSString *)turnRGBToHex16:(int)r G:(int)g B:(int)b{
    int c = RGB(r,g,b);
    NSString *str = [NSString stringWithFormat:@"0x%06x",c];
    return str;
}
/**************16进制提取rgb转uicolor*****************/
+(UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}



@end
