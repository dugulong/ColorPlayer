//
//  StandardColorViewController.h
//  ColorPlay
//
//  Created by long_zhang on 14-10-21.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

typedef void(^ColorBlock)(NSDictionary *colorDic);

@interface StandardColorViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    ColorBlock _colorBlock;
}

-(void)didSelectTheColor:(ColorBlock)colorBlock;
@end
