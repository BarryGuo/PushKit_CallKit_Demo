//
//  ProviderDelegate.h
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import "CallController.h"

@interface ProviderDelegate : NSObject<CXProviderDelegate>

- (instancetype)initWithCallController:(CallController*)callController;

- (void)reportIncomingCall;

@end
