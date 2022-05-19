

#import <Foundation/Foundation.h>

@interface JQLaunchAdManager : NSObject
+ (nonnull instancetype )shareManager;
-(void)setupJQLaunchAdWithAppkey:(NSString * _Nonnull)key andSecret:(NSString * _Nonnull)secret;
@end
