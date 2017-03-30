//
//  ViewController.m
//  ZNNineGridUnlock
//
//  Created by FunctionMaker on 2017/3/23.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "ViewController.h"
#import "ZNNineGridsUnlockView.h"

@interface ViewController () <ZNUnlockCallBack>

@property (strong, nonatomic) ZNNineGridsUnlockView *NGUView;

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.NGUView];
}

#pragma mark - Delegate Call back

- (void)ZNUnlockCallBackWithStatus:(NSString *)status andPWD:(NSString *)pwd {
#warning 代理回调修改被代理对象属性值无效
    NSLog(@"status:%@ pwd:%@", status, pwd);
}

#pragma mark - Getter

- (ZNNineGridsUnlockView *)NGUView {
    if (!_NGUView) {
        _NGUView = [[ZNNineGridsUnlockView alloc] init];
        _NGUView.delegate = self;
        _NGUView.unlockStatus = ZNUnlockStatusSettingPWD;
        
        //custom your style
    
        //if you want to change images, you should init view by method the following:
        //_NGUView = [[ZNNineGridsUnlockView alloc] initWithSelectedImageName:@"btnSelected" unselectedImageName:@"btnUnselected" unlockFailedImageName:@"unlockFailed"];
        
        //_NGUView.backgroundColor = [UIColor grayColor]; //default is clear color
        
        //_NGUView.strokeLineColor = [UIColor orangeColor]; //default is adaptable selected image build in kit
        
        //_NGUView.ShouldShowStrokeProcessing = NO; //default is YES
    }
    
    return _NGUView;
}

//simulate the actual use
- (IBAction)inputPWD:(UIButton *)sender {
    self.NGUView.unlockStatus = ZNUnlockStatusInputPWD;
    [self.view addSubview:self.NGUView];
}

- (IBAction)resetPWD:(UIButton *)sender {
    self.NGUView.unlockStatus = ZNUnlockStatusResetPWD;
}

@end
