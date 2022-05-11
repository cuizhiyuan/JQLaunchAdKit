

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JQLaunchAdDownloader.h"

typedef NS_OPTIONS(NSUInteger, JQLaunchAdImageOptions) {
    /** 有缓存,读取缓存,不重新下载,没缓存先下载,并缓存 */
    JQLaunchAdImageDefault = 1 << 0,
    /** 只下载,不缓存 */
    JQLaunchAdImageOnlyLoad = 1 << 1,
    /** 先读缓存,再下载刷新图片和缓存 */
    JQLaunchAdImageRefreshCached = 1 << 2 ,
    /** 后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式)*/
    JQLaunchAdImageCacheInBackground = 1 << 3
};

typedef void(^XHExternalCompletionBlock)(UIImage * _Nullable image,NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL);

@interface JQLaunchAdImageManager : NSObject

+(nonnull instancetype )sharedManager;
- (void)loadImageWithURL:(nullable NSURL *)url options:(JQLaunchAdImageOptions)options progress:(nullable JQLaunchAdDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock;

@end
