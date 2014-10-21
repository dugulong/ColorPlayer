//
//  ViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-20.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "ViewController.h"
#import "ConvertViewController.h"
#import "FristViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.test
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"], [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
    
    [self setMainButton];
}


-(void)setMainButton{
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100,50+120*i, 100, 100);
        button.backgroundColor = [UIColor redColor];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(30, 50)];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(30, 50)];
}

-(void)buttonPress:(UIButton *)button{
    NSLog(@"buttonPress");
    if (button.tag ==1000) {
        ConvertViewController *convertVC = [[ConvertViewController alloc]init];
        [self.navigationController pushViewController:convertVC animated:YES];
    }else if (button.tag ==1001){
        FristViewController *frist = [[FristViewController alloc]init];
        [self.navigationController pushViewController:frist animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - CDSideBarController delegate

- (void)menuButtonClicked:(int)index
{
    NSLog(@"index:%d",index);
    // Execute what ever you want
}
@end

