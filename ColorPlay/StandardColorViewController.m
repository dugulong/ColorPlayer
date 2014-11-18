//
//  StandardColorViewController.m
//  ColorPlay
//
//  Created by long_zhang on 14-10-21.
//  Copyright (c) 2014年 admaster. All rights reserved.
//

#import "StandardColorViewController.h"
#import "ColorFactory.h"

@implementation StandardColorViewController{
    UITableView *_tableView ;
    
    NSArray *_dataArray;
}


-(void)viewDidLoad{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"rgb" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0, screenSize.width,screenSize.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setBackButtonPress];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"cell";
    UITableViewCell *cell= nil;
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        NSString *hexColor = [dic objectForKey:@"t16str"];
        
//        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%@  %@  %@",[dic objectForKey:@"chinese"],[dic objectForKey:@"rgbStr"],hexColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [ColorFactory getColor:hexColor];
        [cell.contentView addSubview:label];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;//取消选中效果。
    return cell;
}

-(void)didSelectTheColor:(ColorBlock)colorBlock{
    _colorBlock = colorBlock;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    _colorBlock(dic);

}
@end
