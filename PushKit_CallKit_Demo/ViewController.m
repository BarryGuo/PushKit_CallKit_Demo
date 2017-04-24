//
//  ViewController.m
//  PushKit_CallKit_Demo
//
//  Created by Barry on 2017/4/21.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "ViewController.h"
#import "ProviderDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *IncomingCallButtom;
@property (weak, nonatomic) IBOutlet UIButton *outCallButton;

@property (nonatomic, strong) ProviderDelegate * provider;
@property (nonatomic, strong) CallController * callController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _callController = [[CallController alloc] init];
    _provider = [[ProviderDelegate alloc] initWithCallController:_callController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)incomingCallTouched:(id)sender {
    NSLog(@"收到来电");
    
    [_provider reportIncomingCall];
}

- (IBAction)outCallButtonTouched:(UIButton *)sender {
    NSLog(@"发起来电");
    
    [_callController startCall:@"18211301722"];
}



@end
