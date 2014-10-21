//
//  SuperViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()
{
    UIButton *_backButton;
}
@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonPress];
}

-(void)setBackButtonPress{
    if (_backButton ==nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20,40,40,40);
        [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }else{
        [self.view bringSubviewToFront:_backButton];
    }
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
