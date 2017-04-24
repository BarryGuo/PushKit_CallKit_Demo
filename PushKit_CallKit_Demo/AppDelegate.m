//
//  AppDelegate.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "AppDelegate.h"

#import "NSString+UCLog.h"

#import <PushKit/PushKit.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "GlobalDefine.h"

#import "ProviderDelegate.h"
#import "CallController/CallController.h"

@interface AppDelegate ()<PKPushRegistryDelegate,UNUserNotificationCenterDelegate>


@property (nonatomic, strong) ProviderDelegate * provider;
@property (nonatomic, strong) CallController * callController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [@"didFinishLaunchingWithOptions" saveTolog];
    
    [self registePushAndLocalNoti];
    
    [self registPushKit];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self incomingCall];
   
}


- (void)incomingCall{
    _callController = [[CallController alloc] init];
    
    _provider = [[ProviderDelegate alloc] initWithCallController:_callController];
    
    [_provider reportIncomingCall];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark 通知授权和 apns注册
- (void)registePushAndLocalNoti{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(10.0)) {
        [self registLocalNotification];  //获取通知授权
        [[UIApplication sharedApplication] registerForRemoteNotifications];  //注册apns
        
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0)){
        
        UIApplication *application = [UIApplication sharedApplication];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings]; //获取授权
        
        [application registerForRemoteNotifications];  //注册apns
    }else{
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

#pragma mark - ios10以上获取本地通知和远程通知授权
- (void)registLocalNotification{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  NSLog(@"注册成功");
                              }else{
                                  //点击不允许
                                  NSLog(@"注册失败");
                              }
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
        {
            NSLog(@"未选择");
        }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
            NSLog(@"未授权");
        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
            NSLog(@"已授权");
        }
    }];
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceToken1 = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken1 forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"收到推送token %@", deviceToken1);
    [[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken1] saveTolog];
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}





#pragma mark - UNUserNotificationCenterDelegate
//只有在active的状态才会触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

//通知点击回调，本地、远程统一
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
        [[NSString stringWithFormat:@"didReceiveNotificationResponse : %@", userInfo.description] saveTolog];
        
    }else {
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(); // 系统要求执行这个方法
}





#pragma mark -iOS 10之前收到通知
//调用场景：前台收到离线推送、后台收到离线推送点击进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7以上、iOS 10以下系统，收到远程通知:%@", userInfo);
    [[NSString stringWithFormat:@"didReceiveRemoteNotification : %@", userInfo.description] saveTolog];
    completionHandler(UIBackgroundFetchResultNewData);
}
//只有active的状态才会触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"iOS 10以下系统，收到本地通知:%@",notification.userInfo );
}




#pragma mark 注册pushkit 和 代理方法
- (void)registPushKit{
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version >= 8.0) {
        PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString * _tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSString stringWithFormat:@"pushkit_didUpdatePushCredentials: %@", _tokenStr] saveTolog];
    
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    
    [[NSString stringWithFormat:@"didReceiveIncomingPushWithPayload: %@", payload.description] saveTolog];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(10.0)){
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body = @"pushkit本地通知";
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 0.001s 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:0.001 repeats:NO];
        //创建一个通知请求
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"pushkit"
                                                                              content:content trigger:trigger];
        
        //将通知请求添加到通知中心
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else{
        UILocalNotification *localNot = [[UILocalNotification alloc] init];
        localNot.fireDate = [NSDate date];
        localNot.alertBody = @"pushkit本地通知";
        localNot.soundName = UILocalNotificationDefaultSoundName;
        localNot.timeZone = [NSTimeZone defaultTimeZone];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
    }
    
    
    
}


@end
