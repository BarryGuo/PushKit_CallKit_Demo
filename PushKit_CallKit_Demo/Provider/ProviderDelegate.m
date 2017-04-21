//
//  ProviderDelegate.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "ProviderDelegate.h"
#import "GlobalDefine.h"


@interface ProviderDelegate ()
@property (nonatomic, strong) CXProvider * provider;

@property (nonatomic, readonly) CXProviderConfiguration * config;

@property (nonatomic, weak) CallController * callController;

@end

@implementation ProviderDelegate

- (CXProviderConfiguration *)config{
    static CXProviderConfiguration* configInternal = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configInternal = [[CXProviderConfiguration alloc] initWithLocalizedName:@"MyCall"];
        configInternal.supportsVideo = YES;
        configInternal.maximumCallsPerCallGroup = 1;
        configInternal.maximumCallGroups = 1;
        configInternal.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypePhoneNumber)];
        UIImage* iconMaskImage = [UIImage imageNamed:@"IconMask"];
        configInternal.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage);
        configInternal.ringtoneSound = @"Ringtone.caf";
    });
    
    return configInternal;
}


- (instancetype)initWithCallController:(CallController *)callController{
    self = [super init];
    if (self) {
        self.callController = callController;
        _provider = [[CXProvider alloc] initWithConfiguration:self.config];
        [_provider setDelegate:self queue:nil];
    }
    return  self;
}

- (void)reportIncomingCall{
    CXCallUpdate* update = [[CXCallUpdate alloc] init];
    update.hasVideo = NO;
    update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:self.callController.currentHandle];
    
    [self.provider reportNewIncomingCallWithUUID:self.callController.currentUUID update:update completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"report error");
        }
    }];
}




#pragma mark CXProviderDelegate

- (void)providerDidReset:(CXProvider *)provider{
    
}


/// Called when the provider has been fully created and is ready to send actions and receive updates
- (void)providerDidBegin:(CXProvider *)provider{
    
}


- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action{
    
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{
    NSUUID* currentID = self.callController.currentUUID;
    if ([[action.callUUID UUIDString] isEqualToString:[currentID UUIDString]]) {
        [self.callController answerCall];
        [action fulfill];
    } else {
        [action fail];
    }
}
- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{
    NSUUID* currentID = self.callController.currentUUID;
    if ([[action.callUUID UUIDString] isEqualToString:[currentID UUIDString]]) {
//        [self.callController.callManager stopCall];
        [action fulfill];
    } else {
        [action fail];
    }
}
- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action{
    
}
- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action{
    
}
- (void)provider:(CXProvider *)provider performSetGroupCallAction:(CXSetGroupCallAction *)action{
    
}
- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action{
    
}

/// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action{
    
}

/// Called when the provider's audio session activation state changes.
- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession{
    
}
- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession{
    
}


@end
