//
//  ViewController.m
//  alipayDemo
//
//  Created by 张国荣 on 16/6/24.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "ViewController.h"
#import "Product.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, strong)NSMutableArray *productList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateData];
}
#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)generateData{
//    NSArray *subjects = @[@"1",
//                          @"2",@"3",@"4",
//                          @"5",@"6",@"7",
//                          @"8",@"9",@"10"];
    NSArray *body = @[@"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据"];
    
    self.productList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [body count]; ++i) {
        Product *product = [[Product alloc] init];
        product.productName = [body objectAtIndex:i];
        product.price = 0.01f+pow(10,i-2);
        [self.productList addObject:product];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productList count];
}




//
//用TableView呈现测试数据,外部商户不需要考虑
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"Cell"];
    
    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = product.productName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
    
    return cell;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [self.productList objectAtIndex:indexPath.row];
    AppDelegate *appdele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdele payByAlipay:product];
  
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
