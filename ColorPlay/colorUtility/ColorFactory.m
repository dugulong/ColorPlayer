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





typedef struct
{
    double r;       // percent [0 - 1]
    double g;       // percent [0 - 1]
    double b;       // percent [0 - 1]
    double a;       // percent [0 - 1]
} RGBA;

typedef struct
{
    double h;       // angle in degrees [0 - 360]
    double s;       // percent [0 - 1]
    double v;       // percent [0 - 1]
} HSV;

- (RGBA)RGBfromHSV:(HSV)value
{
    double      hh, p, q, t, ff;
    long        i;
    RGBA        out;
    out.a       = 1;
    
    if (value.s <= 0.0) // < is bogus, just shuts up warnings
    {
        if (isnan(value.h)) // value.h == NAN
        {
            out.r = value.v;
            out.g = value.v;
            out.b = value.v;
            return out;
        }
        
        // error - should never happen
        out.r = 0.0;
        out.g = 0.0;
        out.b = 0.0;
        return out;
    }
    
    hh = value.h;
    if(hh >= 360.0) hh = 0.0;
    hh /= 60.0;
    i = (long)hh;
    ff = hh - i;
    p = value.v * (1.0 - value.s);
    q = value.v * (1.0 - (value.s * ff));
    t = value.v * (1.0 - (value.s * (1.0 - ff)));
    
    switch(i)
    {
        case 0:
            out.r = value.v;
            out.g = t;
            out.b = p;
            break;
        case 1:
            out.r = q;
            out.g = value.v;
            out.b = p;
            break;
        case 2:
            out.r = p;
            out.g = value.v;
            out.b = t;
            break;
            
        case 3:
            out.r = p;
            out.g = q;
            out.b = value.v;
            break;
        case 4:
            out.r = t;
            out.g = p;
            out.b = value.v;
            break;
        case 5:
        default:
            out.r = value.v;
            out.g = p;
            out.b = q;
            break;
    }
    return out;     
}

@end
