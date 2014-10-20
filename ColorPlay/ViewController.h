//
//  ViewController.h
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDSideBarController.h"


@interface ViewController : UIViewController <CDSideBarControllerDelegate>
{
    CDSideBarController *sideBar;
}



@end

