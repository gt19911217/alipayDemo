# alipayDemo
博客链接 ：  http://blog.csdn.net/zhonggaorong/article/details/51750341

iOS开发之第三方支付支付宝支付教程，史上最新最全第三方支付宝支付方式实现、支付宝集成教程，支付宝实现流程
支付宝支付大致流程为 ：

1. 公司与支付宝进行签约 ， 获得商户ID（partner）和账号ID（seller）和私钥(privateKey)，开发中用到的，很重要。

请商户在b.alipay.com里进行产品签约；
审核：商户登录qy.alipay.com，可在“签约订单”中查看审核进度。
2.  下载支付宝SDK      网址：https://doc.open.alipay.com/doc2/detail.htm?treeId=54&articleId=104509&docType=1
3.   生成订单 ，签名加密。

4.   开始支付，调起支付宝客户端或者网页端，然后进行支付，由支付宝与银行系统进行打交道，并由支付宝返回处理的结果给客户端。

5.  展示对应的支付结果给客户。


下面详细介绍， 商户公钥，商户私钥，支付宝公钥，支付宝私钥，RSA生成方式，DSA生成方式。
商户公钥： 这个上传到支付宝后台换取 支付宝的公钥 、 支付宝公钥（后面代码中会用到，非常重要）
商户私钥：  这个下订单的时候会用到。                                   （非常重要）
支付宝公钥： 由商户公钥上传到支付宝后台生成 支付宝公钥 （非常重要）



1.商户公钥与商户私钥的生成 （DSA方式）：
生成方式一（推荐）：使用支付宝提供的一键生成工具（内附使用说明）

Windows：下载 MAC OSX：下载

OpenSSL>
 pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt -out rsa_private_key_pkcs8.pem #Java开发者需要将私钥转换成PKCS8格式
OpenSSL>
 rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem #生成公钥
OpenSSL>
 exit #退出OpenSSL程序

 解压打开文件夹，直接运行“支付宝RAS密钥生成器SHAwithRSA1024_V1.0.bat”（WINDOWS）或“SHAwithRSA1024_V1.0.command”（MACOSX），点击“生成RSA密钥”，会自动生成公私钥，然后点击“打开文件位置”，即可找到工具自动生成的密钥。

 生成方式二：也可以使用OpenSSL工具命令生成

首先进入OpenSSL工具，再输入以下命令。

OpenSSL>
 genrsa -out rsa_private_key.pem   1024 #生成私钥


经过以上步骤，开发者可以在当前文件夹中（OpenSSL运行文件夹），看到rsa_private_key.pem（RSA私钥）、rsa_private_key_pkcs8.pem（pkcs8格式RSA私钥）和rsa_public_key.pem（对应RSA公钥）3个文件。开发者将私钥保留，将公钥提交给支付宝网关，用于验证签名。以下为私钥文件和公钥文件示例。

注意：对于使用Java的开发者，将pkcs8在console中输出的私钥去除头尾、换行和空格，作为开发者私钥，对于.NET和PHP的开发者来说，无需进行pkcs8命令行操作。

更详细信息： https://doc.open.alipay.com/doc2/detail?treeId=58&articleId=103242&docType=1

2.商户公钥与商户私钥的生成 （DSA方式）： 
进入OpenSSL工具，再输入以下命令。

1
2
3
4
5

OpenSSL>
 dsaparam -out dsa_param.pem 1024  #生成参数文件

OpenSSL>
 gendsa -out dsa_private_key.pem dsa_param.pem #生成私钥

OpenSSL>
 pkcs8 -topk8 -inform PEM -in dsa_private_key.pem -outform PEM -nocrypt -out dsa_private_key_pkcs8.pem #Java开发者需要将私钥转换成PKCS8格式

OpenSSL>
 dsa -in dsa_private_key_pkcs8.pem -pubout -out dsa_public_key.pem #生成公钥

OpenSSL>
 exit #退出OpenSSL程序

经过以上步骤，开发者可以在当前文件夹中（OpenSSL运行文件夹），看到dsa_private_key.pem（DSA私钥）、dsa_private_key_pkcs8.pem（pkcs8格式DSA私钥）、dsa_public_key.pem（对应DSA公钥）和dsa_param.pem（参数文件）4个文件。开发者将私钥保留，将公钥提交给支付宝网关，用于验证签名。

注意：对于使用Java的开发者，将pkcs8在console中输出的私钥去除头尾、换行和空格，作为开发者私钥，对于.NET和PHP的开发者来说，无需进行pkcs8命令行操作。

更详细信息：https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.JDjRVa&treeId=58&articleId=103581&docType=1

3. 上传RSA 商户公钥 ， 获取支付宝公钥。 以及查看支付宝 RSA生成公钥。
   上传RSA商户公钥：  https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.kDer5c&treeId=58&articleId=103578&docType=1
   查看支付宝RSA生成公钥：  https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.50COsb&treeId=58&articleId=103546&docType=1

4. 上传DSA商户公钥 ， 获取支付宝公钥。 以及查看支付宝DSA生成公钥。
   上传DSA商户公钥：https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.6SrtUf&treeId=58&articleId=103577&docType=1
   查看支付宝DSA生成公钥：  https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.c9oA4U&treeId=58&articleId=103576&docType=1



通过上面的讲解：

大家应该吧 ： 商户私钥、 支付宝公钥、 商户ID（partner）和账号ID（seller） 都记录下来。



3.支付宝 SDK 集成讲解：
1. 从下载出来的SDK中吧以下文件取出来，并保存到另外一个文件夹，如下文件：



2。我们把上面这个文件拖入新建的工程里面。

3. 导入依赖库 (出现莫名其妙的错误的时候，多检查下 依赖库， 看是不是添加少了)


然后编译程序， 然后发现 unknown type nesting ，int, nsdata之类的语句， 这个是因为没有引入对应的框架。

解决办法在出错的类里面加上

[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  


    


在编译程序：说openssl/asn1.h not found.


 

解决方法如下：



现在编译项目，应该是编译通过了。 


设置 URL types 



设置 支付宝白名单。 在info.plist 文件中添加




项目结构预览：



4.正式编码：

appdelegate.h
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#import <UIKit/UIKit.h>  
#import "Product.h"  
  
@protocol  alipyDelegate <NSObject>  
  
-(void)alipydidSuccess;  
-(void)alipydidFaile;  
  
@end  
@interface AppDelegate : UIResponder <UIApplicationDelegate>  
  
@property (strong, nonatomic) UIWindow *window;  
@property (weak  , nonatomic) id<alipyDelegate> aliDelegate;  
  
-(void)payByAlipay:(Product *)product;  
@end  



appDelegate.m
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
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


ViewController.h
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#import <UIKit/UIKit.h>  
  
@interface ViewController : UIViewController  
  
  
@end  


ViewController.m
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
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


Product.h
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#import <Foundation/Foundation.h>  
  
@interface Product : NSObject  
  
@property (nonatomic, copy)   NSString* productName;  
@property (nonatomic, assign) float price;  
  
@end  



product.m
[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#import "Product.h"  
  
@implementation Product  
  
@end  


