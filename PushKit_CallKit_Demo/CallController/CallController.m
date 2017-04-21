//
//  CallController.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "CallController.h"

@implementation CallController

- (NSUUID *)currentUUID{
    return  [NSUUID UUID];
}

- (NSString *)currentHandle{
    return @"18211301722";
}


- (void)answerCall{
    NSLog(@"answerCall");
}


@end
