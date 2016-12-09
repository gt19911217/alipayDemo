//
//  AppDelegate.m
//  alipayDemo
//
//  Created by 张国荣 on 16/6/24.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Product.h"
#import "Order.h"
#import "DataSigner.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [self alipayUrlAction:url];
     return YES;
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //有多中支付方式，要用scheme 来进行判断，看是那种途径的url.
    [self alipayUrlAction:url];
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [self alipayUrlAction:url];
     return YES;
}

-(void)alipayUrlAction:(NSURL *)url{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {
            if ([_aliDelegate respondsToSelector:@selector(alipydidSuccess)]) {
                [_aliDelegate alipydidSuccess];
            }
        }else{
            if ([_aliDelegate respondsToSelector:@selector(alipydidFaile)]) {
                [_aliDelegate alipydidFaile];
            }
        }
    }];
}

-(void)payByAlipay:(Product *)product{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    
    NSString *partner = @"";        //商户id
    NSString *seller = @"";         //账户id  签约账号。
    NSString *privateKey = @"";     // md5
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = @"xxxxxx"; //订单ID（由商家自行制定）
    order.subject = product.productName; //商品标题
    order.body = product.productName; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {  //成功
                if ([_aliDelegate respondsToSelector:@selector(alipydidSuccess)]) {
                    [_aliDelegate alipydidSuccess];
                }
            }else{  //失败
                if ([_aliDelegate respondsToSelector:@selector(alipydidFaile)]) {
                    [_aliDelegate alipydidFaile];
                }
            }

            
        }];
    }

}

@end
