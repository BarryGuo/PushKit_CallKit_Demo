//
//  ProviderDelegate.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "ProviderDelegate.h"
#import "GlobalDefine.h"

#import <AVFoundation/AVFoundation.h>

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
        //系统来电页面显示的app名称和系统通讯记录的信息
        configInternal = [[CXProviderConfiguration alloc] initWithLocalizedName:@"MyCall"];
        //是否支持视频
        configInternal.supportsVideo = NO;
        //最大通话组
        configInternal.maximumCallsPerCallGroup = 1;
        configInternal.maximumCallGroups = 1;
        //支持的handle类型
        configInternal.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypePhoneNumber)];
        //锁屏接听时，系统界面右下角的app图标，要求40 x 40大小
        UIImage* iconMaskImage = [UIImage imageNamed:@"IconMask"];
        configInternal.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage);
        //来电铃声
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
    
    NSUUID* currentID = self.callController.currentUUID;
    if ([[action.callUUID UUIDString] isEqualToString:[currentID UUIDString]]) {
        configureAudioSession();
        // your code
        
        [action fulfill];
    } else {
        [action fail];
    }

}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{

    NSUUID* currentID = self.callController.currentUUID;
    if ([[action.callUUID UUIDString] isEqualToString:[currentID UUIDString]]) {
        configureAudioSession();
        //your code
        [action fulfill];
    } else {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{
    NSUUID* currentID = self.callController.currentUUID;
    if ([[action.callUUID UUIDString] isEqualToString:[currentID UUIDString]]) {
       //your code
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
    // you code
    //在这里启动应用的音视频逻辑
}
- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession{
    
}



#pragma mark - CallAudio
void configureAudioSession(){
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"couldn't set session's audio category");
    }
}



@end
