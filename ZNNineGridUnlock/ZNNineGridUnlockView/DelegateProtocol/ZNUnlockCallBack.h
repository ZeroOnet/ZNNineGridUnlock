//
//  ZNUnlockCallBack.h
//  ZNNineGridUnlock
//
//  Created by FunctionMaker on 2017/3/23.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#ifndef ZNUnlockCallBack_h
#define ZNUnlockCallBack_h

@protocol ZNUnlockCallBack <NSObject>

@required

- (void)ZNUnlockCallBackWithStatus:(NSString *)status andPWD:(NSString *)pwd;

@end

#endif 
