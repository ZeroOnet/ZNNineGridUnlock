//
//  ZNNineGridsUnlockView.m
//  ZNNineGridUnlock
//
//  Created by FunctionMaker on 2017/3/23.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "ZNNineGridsUnlockView.h"

#define kDefaultSelectedImageName       @"btnSelected"
#define kDefaultUnselectedImageName     @"btnUnselected"
#define kDefaultUnlockFailedImageName   @"unlockFailed"

#define kAroundMargin                   40.0f
#define kCloseElementMargin             ((self.frame.size.width - 3 * 60.0f) / 2.0f)
#define kElementSize                    60.0f

@interface ZNNineGridsUnlockView () {
    NSString *_selectedImageName;
    NSString *_unselectedImageName;
    NSString *_unlockFailedImageName;
    
    CGPoint _strokeStartLocation;
    CGPoint _strokeDestinationLocation;
    
    NSInteger _failedCount;
}

@property (strong, nonatomic) NSMutableArray<UIButton *> *grids;
@property (strong, nonatomic) NSMutableArray<UIButton *> *selectedGrids;

@property (assign, nonatomic, getter=isShouldStroke) BOOL shouldStroke;
@property (assign, nonatomic, getter=isFinishStroking) BOOL finishStroking;

@property (strong, nonatomic) UIBezierPath *strokeEnd;
@property (strong, nonatomic) UIImageView *strokeLineShowView;

@end

@implementation ZNNineGridsUnlockView

#pragma mark - initializer

- (instancetype)init {
    self = [super init];
    
    if (self) {
        if (!_selectedImageName || !_unselectedImageName || !_unlockFailedImageName) {
            _selectedImageName = kDefaultSelectedImageName;
            _unselectedImageName = kDefaultUnselectedImageName;
            _unlockFailedImageName = kDefaultUnlockFailedImageName;
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.ShouldShowStrokeProcessing = YES;
        
        [self addSubview:self.strokeLineShowView];
        
        [self.grids enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:self.grids[idx]];
        }];
    }
    
    return self;
}

- (instancetype)initWithSelectedImageName:(NSString *)selectedImageName unselectedImageName:(NSString *)unselectedImageName unlockFailedImageName:(NSString *)unlockFailedImageName {
    _selectedImageName = selectedImageName;
    _unselectedImageName = unselectedImageName;
    _unlockFailedImageName = unlockFailedImageName;
    
    self = [self init];
    
    return self;
}

#pragma mark - Layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview) {
        self.frame = CGRectMake(kAroundMargin, self.superview.frame.size.height - (self.superview.frame.size.width - 2 * kAroundMargin + kAroundMargin), self.superview.frame.size.width - 2 * kAroundMargin, self.superview.frame.size.width - 2 * kAroundMargin);
        
        self.strokeLineShowView.frame = self.bounds;
        
        [self.grids enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake((idx % 3) * (kElementSize + kCloseElementMargin), (idx / 3) * (kElementSize +kCloseElementMargin), kElementSize, kElementSize);
        }];
    }
}

#pragma mark - View touch response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touchLocation = [touches anyObject];
    CGPoint location = [touchLocation locationInView:self];
    
    [self.grids enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, location) && !obj.selected) {
            if (self.isShouldShowStrokeProcessing) {
                [obj setImage:[UIImage imageNamed:_selectedImageName] forState:UIControlStateNormal];
    
                _strokeStartLocation = obj.center;
            }
            
            obj.selected = YES;
            
            [self.selectedGrids addObject:obj];
        }
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touchLocation = [touches anyObject];
    CGPoint location = [touchLocation locationInView:self];
    
    if (_strokeStartLocation.x != 0 && self.isShouldShowStrokeProcessing) {
        
        [self setNeedsDisplay];
        _strokeDestinationLocation = location;
    }
    
    [self.grids enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, location) && !obj.selected) {
            if (self.isShouldShowStrokeProcessing) {
                [obj setImage:[UIImage imageNamed:_selectedImageName] forState:UIControlStateNormal];
                
                if (_strokeStartLocation.x != 0) {
                    _strokeDestinationLocation = obj.center;
                    self.shouldStroke = YES;
                    
                    [self setNeedsDisplay];
                } else {
                    _strokeStartLocation = obj.center;
                }
            }
            
            obj.selected = YES;
            
            [self.selectedGrids addObject:obj];
        }
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_selectedGrids || _selectedGrids.count == 0) {
        return;
    }
    
    self.userInteractionEnabled = NO;
    self.finishStroking = YES;
    
    NSString *selectedPWD = [self getPWDFromSelectedGrids];
    
    switch (_unlockStatus) {
        case ZNUnlockStatusSettingPWD:
            [[NSUserDefaults standardUserDefaults] setObject:selectedPWD forKey:kZNNineGridUnlockPWD];
            _unlockStatus = ZNUnlockStatusEnsurePWD;
            
            [self resetZNUnlockView];
            break;
        case ZNUnlockStatusEnsurePWD:
            if ([selectedPWD isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kZNNineGridUnlockPWD]]) {
                _unlockStatus = ZNUnlockStatusSettingPWDSuccessed;
                [self resetZNUnlockView];
                [self dismissUnlockView];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kZNNineGridUnlockPWD];
                _unlockStatus = ZNUnlockStatusSettingPWDFailed;
            }
            break;
        case ZNUnlockStatusInputPWD:
            if (![selectedPWD isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kZNNineGridUnlockPWD]]) {
                _unlockStatus = ZNUnlockStatusFailed;
                
                if (++_failedCount == 5) {
                    _unlockStatus = ZNUnlockStatusErrorWaiting;
                }
            } else {
                _unlockStatus = ZNUnlockStatusSuccessed;
                _failedCount = 0;
                
                [self resetZNUnlockView];
                [self dismissUnlockView];
            }
            break;
        case ZNUnlockStatusResetPWD:
            if (![selectedPWD isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kZNNineGridUnlockPWD]]) {
                _unlockStatus = ZNUnlockStatusResetPWDFailed;
            } else {
                _unlockStatus = ZNUnlockStatusSettingPWD;
                
                [self resetZNUnlockView];
            }
        default:
            break;
    }
    
    [self callBackDelegateWithZNUnlockStatus:_unlockStatus andPWD:selectedPWD];
    
    [self setNeedsDisplay];
}

#pragma mark - Interface method response

- (void)dismissUnlockView {
    [self resetZNUnlockView];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
        self.alpha = 0.1f;
        //self.transform = CGAffineTransformRotate(self.transform, M_PI);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    }];
}

#pragma mark - Redraw view

- (void)drawRect:(CGRect)rect {
    if (self.isFinishStroking) {
        if (_unlockStatus == ZNUnlockStatusSettingPWDFailed || _unlockStatus == ZNUnlockStatusFailed || _unlockStatus == ZNUnlockStatusResetPWDFailed || _unlockStatus == ZNUnlockStatusErrorWaiting) {
            [self strokeALLLines:rect];
            
            if (_unlockStatus == ZNUnlockStatusErrorWaiting) {
                _unlockStatus = ZNUnlockStatusInputPWD;
                [self performSelector:@selector(resetZNUnlockView) withObject:nil afterDelay:20.0f];
            } else {
                _unlockStatus --;
                [self performSelector:@selector(resetZNUnlockView) withObject:nil afterDelay:1.0f];
            }
        }
    }
    
    if (self.isShouldStroke) {
        [self strokeLine:rect];
    } else if (self.isFinishStroking && self.isShouldShowStrokeProcessing) {
        return;//clear ineffective line
    } else {
        UIBezierPath *strokeLine = [UIBezierPath bezierPath];
        [strokeLine moveToPoint:_strokeStartLocation];
        [strokeLine addLineToPoint:_strokeDestinationLocation];
        
        UIColor *strokeColor = self.strokeLineColor != nil ? self.strokeLineColor : [UIColor colorWithRed:54.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:0.7f];
        
        [strokeColor set];
        strokeLine.lineWidth = 2.0f;
        strokeLine.lineCapStyle = kCGLineCapRound;
        
        [strokeLine stroke];
    }
}

#pragma mark - Private method

- (void)resetZNUnlockView {
    [self resetSelectedGridsStatusWithImageName:_unselectedImageName addGridsSelected:NO];
    
    self.strokeLineShowView.image = nil;
    self.strokeEnd = nil;
    _strokeStartLocation = CGPointZero;
    _strokeDestinationLocation = CGPointZero;
    self.finishStroking = NO;
    
    [self.selectedGrids removeAllObjects];

    self.userInteractionEnabled = YES;
}

- (void)callBackDelegateWithZNUnlockStatus:(ZNUnlockStatus)status andPWD:(NSString *)pwd {
    if ([self.delegate respondsToSelector:@selector(ZNUnlockCallBackWithStatus:andPWD:)]) {
        NSString *statusInfo = [NSString string];
        
        switch (status) {
            case 2:
                statusInfo = @"ZNUnlockStatusSettingPWDFailed";
                break;
            case 3:
                statusInfo = @"ZNUnlockStatusSettingPWDSuccessed";
                break;
            case 4:
                statusInfo = @"ZNUnlockStatusEnsurePWD";
                break;
            case 5:
                statusInfo = @"ZNUnlockStatusInputPWD";
                break;
            case 6:
                statusInfo = @"ZNUnlockStatusFailed";
                break;
            case 7:
                statusInfo = @"ZNUnlockStatusSuccessed";
                break;
            case 8:
                statusInfo = @"ZNUnlockStatusResetPWD";
                break;
            case 9:
                statusInfo = @"ZNUnlockStatusResetPWDFailed";
                break;
            case 10:
                statusInfo = @"ZNUnlockStatusErrorWaiting";
                break;
            default:
                break;
        }
        
        [self.delegate ZNUnlockCallBackWithStatus:statusInfo andPWD:pwd];
    }
}

- (void)resetSelectedGridsStatusWithImageName:(NSString *)imageName addGridsSelected:(BOOL)selected {
    [self.selectedGrids enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        obj.selected = selected;
    }];
}

- (NSString *)getPWDFromSelectedGrids {
    NSMutableString *pwd = [NSMutableString stringWithCapacity:9];
    
    for (int i = 0; i < self.selectedGrids.count; i ++) {
        [pwd appendString:[NSString stringWithFormat:@"%zd", self.selectedGrids[i].tag]];
    }
    
    return pwd;
}

- (void)strokeLine:(CGRect)rect {
    if (self.isShouldShowStrokeProcessing) {
        UIGraphicsBeginImageContext(self.strokeLineShowView.frame.size);
        
        [self.strokeEnd moveToPoint:_strokeStartLocation];
        [self.strokeEnd addLineToPoint:_strokeDestinationLocation];
        
        
        UIColor *strokeColor = self.strokeLineColor != nil ? self.strokeLineColor : [UIColor colorWithRed:54.0f / 255.0f green:140.0f / 255.0f blue:220.0f / 255.0f alpha:0.7f];
        
        [strokeColor set];
        
        [self.strokeEnd closePath];
        [self.strokeEnd stroke];
        
        self.strokeLineShowView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.shouldStroke = NO;
        
        _strokeStartLocation = self.selectedGrids.lastObject.center;
    }
}

- (void)strokeALLLines:(CGRect)rect {
    UIGraphicsBeginImageContext(self.strokeLineShowView.frame.size);
    
    UIBezierPath *strokeAllLines = [UIBezierPath bezierPath];
    strokeAllLines.lineWidth = 2.0f;
    strokeAllLines.lineCapStyle = kCGLineCapRound;
    
    for (int i = 0; i < self.selectedGrids.count - 1; i ++) {
        if (i == 0) {
            [strokeAllLines moveToPoint:self.selectedGrids[0].center];
        }
        
        [strokeAllLines addLineToPoint:self.selectedGrids[i + 1].center];
        [strokeAllLines moveToPoint:self.selectedGrids[i + 1].center];
    }
    
    [[UIColor redColor] set];
    
    [strokeAllLines closePath];
    [strokeAllLines stroke];
    
    self.strokeLineShowView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self resetSelectedGridsStatusWithImageName:_unlockFailedImageName addGridsSelected:YES];
}

#pragma mark - Setters and getters

//if you custom getter and setter of property, you should compose _property instance with @synthesize
- (void)setStrokeLineColor:(UIColor *)strokeLineColor {
    if (strokeLineColor) {
        _strokeLineColor = strokeLineColor;
    }
}

- (void)setUnlockStatus:(ZNUnlockStatus)unlockStatus {
    if (unlockStatus == 1 || unlockStatus == 5 || unlockStatus == 8) {
        if (_unlockStatus != unlockStatus) {
            _unlockStatus = unlockStatus;
        }
    } else {
        NSAssert(NO, @"only three status of ZNUnlockStatus can be setted:ZNUnlockStatusSettingPWD、ZNUnlockStatusInputPWD、ZNUnlockStatusResetPWD, others just be used to show ZNUnlockStatus information");
    }
}

- (NSMutableArray<UIButton *> *)grids {
    if (!_grids) {
        _grids = [NSMutableArray arrayWithCapacity:9];
        
        for (int i = 0; i < 9; i ++) {
            UIButton *grid = [UIButton buttonWithType:UIButtonTypeCustom];
            [grid setImage:[UIImage imageNamed:_unselectedImageName] forState:UIControlStateNormal];
            grid.enabled = NO;
            grid.adjustsImageWhenHighlighted = NO;
            grid.adjustsImageWhenDisabled = NO;
            grid.tag = i;
            
            [_grids addObject:grid];
        }
    }
    
    return _grids;
}

- (NSMutableArray<UIButton *> *)selectedGrids {
    if (!_selectedGrids) {
        _selectedGrids = [NSMutableArray arrayWithCapacity:9];
    }
    
    return _selectedGrids;
}

- (UIBezierPath *)strokeEnd {
    if (!_strokeEnd) {
        _strokeEnd = [UIBezierPath bezierPath];
        _strokeEnd.lineWidth = 2.0f;
        _strokeEnd.lineCapStyle = kCGLineCapRound;
    }
    
    return _strokeEnd;
}

- (UIImageView *)strokeLineShowView {
    if (!_strokeLineShowView) {
        _strokeLineShowView = [[UIImageView alloc] init];
        _strokeLineShowView.backgroundColor = [UIColor clearColor];
    }
    
    return _strokeLineShowView;
}

@end
