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
    NSLog(@"status:%@ pwd:%@", status, pwd);
    /*
     2017-08-16 13:30:38.290 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusEnsurePWD pwd:012
     2017-08-16 13:30:40.133 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSettingPWDFailed pwd:04
     2017-08-16 13:30:42.665 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusEnsurePWD pwd:012
     2017-08-16 13:30:45.084 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSettingPWDSuccessed pwd:012
     2017-08-16 13:34:45.706 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:04
     2017-08-16 13:34:48.381 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:036
     2017-08-16 13:34:51.535 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSuccessed pwd:012
     2017-08-16 13:36:20.682 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:04
     2017-08-16 13:36:22.549 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:03
     2017-08-16 13:36:24.311 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:0
     Aug 16 13:36:24  ZNNineGridUnlock[2663] <Error>: CGPathCloseSubpath: no current point.
     2017-08-16 13:36:26.140 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:4
     Aug 16 13:36:26  ZNNineGridUnlock[2663] <Error>: CGPathCloseSubpath: no current point.
     2017-08-16 13:36:27.756 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusErrorWaiting pwd:1
     Aug 16 13:36:27  ZNNineGridUnlock[2663] <Error>: CGPathCloseSubpath: no current point.
     2017-08-16 13:37:22.392 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusFailed pwd:021
     2017-08-16 13:37:25.671 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSuccessed pwd:012
     2017-08-16 13:37:47.921 ZNNineGridUnlock[2663:97868] status: pwd:012
     2017-08-16 13:37:51.256 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusEnsurePWD pwd:047
     2017-08-16 13:37:53.182 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSettingPWDFailed pwd:012
     2017-08-16 13:37:56.038 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusEnsurePWD pwd:047
     2017-08-16 13:37:58.209 ZNNineGridUnlock[2663:97868] status:ZNUnlockStatusSettingPWDSuccessed pwd:047

     */
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
        
        _NGUView.ShouldShowStrokeProcessing = NO; //default is YES
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
