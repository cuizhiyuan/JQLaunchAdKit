

#import <UIKit/UIKit.h>

/** 启动图来源 */
typedef NS_ENUM(NSInteger,SourceType) {
    /** LaunchImage(default) */
    SourceTypeLaunchImage = 1,
    /** LaunchScreen.storyboard */
    SourceTypeLaunchScreen = 2,
};

typedef NS_ENUM(NSInteger,LaunchImagesSource){
    LaunchImagesSourceLaunchImage = 1,
    LaunchImagesSourceLaunchScreen = 2,
};

@interface JQLaunchImageView : UIImageView

- (instancetype)initWithSourceType:(SourceType)sourceType;

@end
