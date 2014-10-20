//
//  ColorFactory.h
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorFactory : NSObject

+(NSString *)turnRGBToHex16:(int)r G:(int)g B:(int)b;
+(UIColor *)getColor:(NSString *)hexColor;
@end
