

#import <Foundation/Foundation.h>

@interface JQLaunchAdManager : NSObject
+ (nonnull instancetype )shareManager;
-(void)setupJQLaunchAdWithAppKey:(NSString * _Nonnull)key andSecret:(NSString * _Nonnull)secret;
@end
