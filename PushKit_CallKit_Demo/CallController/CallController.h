//
//  CallController.h
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>

@interface CallController : NSObject

@property (nonatomic, strong) NSUUID * currentUUID;
@property (nonatomic, copy) NSString* currentHandle;
@property (nonatomic, copy) NSString *localizedCallerName;
@property (nonatomic) BOOL hasVideo;


- (void)startCall:(NSString*)handle;
- (void)endCall;

@end
