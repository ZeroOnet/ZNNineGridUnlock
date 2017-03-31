# ZNNineGridUnlock

This is a kit to realize nine grids unlock simulates `Android`, you can add a new unlock method for your App with `ZNNineGridUnlock`, including custom your item image or background and stoke line color。Meanwhile，the password of nine grids can be reset after you input previous password successfully！

Your operation is very sample, just like these code as follows：

```Objective-C
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
```
