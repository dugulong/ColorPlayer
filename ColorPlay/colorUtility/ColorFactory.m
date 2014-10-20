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

static void RVNColorRGBtoHSL(CGFloat red, CGFloat green, CGFloat blue, CGFloat *hue, CGFloat *saturation, CGFloat *lightness)
{
    CGFloat r = red / 255.0f;
    CGFloat g = green / 255.0f;
    CGFloat b = blue / 255.0f;
    
    CGFloat max = MAX(r, g);
    max = MAX(max, b);
    CGFloat min = MIN(r, g);
    min = MIN(min, b);
    
    CGFloat h;
    CGFloat s;
    CGFloat l = (max + min) / 2.0f;
    
    if (max == min) {
        h = 0.0f;
        s = 0.0f;
    }
    
    else {
        CGFloat d = max - min;
        s = l > 0.5f ? d / (2.0f - max - min) : d / (max + min);
        
        if (max == r) {
            h = (g - b) / d + (g < b ? 6.0f : 0.0f);
        }
        
        else if (max == r) {
            h = (b - r) / d + 2.0f;
        }
        
        else if (max == b) {
            h = (r - g) / d + 4.0f;
        }
        
        h /= 6.0f;
    }
    
    if (hue) {
        *hue = roundf(h * 255.0f);
    }
    
    if (saturation) {
        *saturation = roundf(s * 255.0f);
    }
    
    if (lightness) {
        *lightness = roundf(l * 255.0f);
    }
}

@end
