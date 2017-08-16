//
//  ZNNineGridsUnlockView.h
//  ZNNineGridUnlock
//
//  Created by FunctionMaker on 2017/3/23.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNUnlockCallBack.h"

#define kZNNineGridUnlockPWD            @"ZNNineGridUnlockPWD"

//#warning 用户能自定义的状态仅为ZNUnlockStatusSettingPWD、ZNUnlockStatusInputPWD、ZNUnlockStatusResetPWD
typedef NS_ENUM(NSUInteger, ZNUnlockStatus) {
    ZNUnlockStatusSettingPWD = 1,//1
    ZNUnlockStatusSettingPWDFailed,
    ZNUnlockStatusSettingPWDSuccessed,
    ZNUnlockStatusEnsurePWD,
    ZNUnlockStatusInputPWD,//5
    ZNUnlockStatusFailed,
    ZNUnlockStatusSuccessed,
    ZNUnlockStatusResetPWD,//8
    ZNUnlockStatusResetPWDFailed,
    ZNUnlockStatusErrorWaiting
};

@interface ZNNineGridsUnlockView : UIView

@property (strong, nonatomic) UIColor *strokeLineColor;

@property (weak, nonatomic) id<ZNUnlockCallBack> delegate;

@property (assign, nonatomic) ZNUnlockStatus unlockStatus;

@property (assign, nonatomic, getter=isShouldShowStrokeProcessing) BOOL ShouldShowStrokeProcessing;

- (instancetype)initWithSelectedImageName:(NSString *)selectedImageName unselectedImageName:(NSString *)unselectedImageName unlockFailedImageName:(NSString *)unlockFailedImageName;

- (void)dismissUnlockView;

@end
