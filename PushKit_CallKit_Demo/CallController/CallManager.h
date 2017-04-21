//
//  CallManager.h
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CallManagerDelegate


@end

@interface CallManager : NSObject

- (void)startCall;
- (void)stopCall;
- (void)acceptCall;

@end
