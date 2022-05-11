

#import "JQLaunchAdController.h"
#import "JQLaunchAdConst.h"

@interface JQLaunchAdController ()

@end

@implementation JQLaunchAdController

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    
    return JQLaunchAdPrefersHomeIndicatorAutoHidden;
}

@end
