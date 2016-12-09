//
//  AppDelegate.h
//  alipayDemo
//
//  Created by 张国荣 on 16/6/24.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

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

