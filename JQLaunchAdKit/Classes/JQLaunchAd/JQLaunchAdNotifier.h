
#import <UIKit/UIKit.h>
#import "Reachability.h"
typedef void(^HandleBlcok)(NetworkStatus networkStatus);
NS_ASSUME_NONNULL_BEGIN

@interface JQLaunchAdNotifier : NSObject
+ (JQLaunchAdNotifier *)shareAdNotifier;
- (void)startNotifierWithHandler:(HandleBlcok)handleBlcok;

@end

NS_ASSUME_NONNULL_END
