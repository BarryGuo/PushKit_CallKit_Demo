//
//  CallController.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "CallController.h"

@interface CallController()

@property (nonatomic, strong) CXCallController * cxCallController;

@end


@implementation CallController


- (instancetype)init{
    if (self = [super init]) {
        _cxCallController = [[CXCallController alloc] init];
    }
    return  self;
}



- (void)startCall:(NSString *)handle{
    self.currentHandle = handle;
    self.currentUUID = [NSUUID UUID];
    CXHandle * handleNumber = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:handle];
    CXStartCallAction * action = [[CXStartCallAction alloc] initWithCallUUID:self.currentUUID handle:handleNumber];
    action.video = NO;
    CXTransaction *transAction = [[CXTransaction alloc] init];
    [transAction addAction:action];
    [self requestTransaction:transAction];
}

- (void)endCall{
    CXEndCallAction * endAction = [[CXEndCallAction alloc] initWithCallUUID:self.currentUUID];
    CXTransaction * transAction = [[CXTransaction alloc] init];
    [transAction addAction:endAction];
    [self requestTransaction:transAction];
}

- (void)requestTransaction:(CXTransaction*)transaction{
    [self.cxCallController requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"requestTransaction error %@", error);
        }
    }];
}



- (NSString *)currentHandle{
    return @"18211301722";
}

- (NSUUID *)currentUUID{
    return [NSUUID UUID];
}

- (void)answerCall{
    NSLog(@"answerCall");
}


@end
