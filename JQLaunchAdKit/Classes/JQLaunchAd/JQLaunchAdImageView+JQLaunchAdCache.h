

#import "JQLaunchAdView.h"
#import "JQLaunchAdImageManager.h"

@interface JQLaunchAdImageView (JQLaunchAdCache)

/**
 设置url图片

 @param url 图片url
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param options JQLaunchAdImageOptions
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(JQLaunchAdImageOptions)options;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param completedBlock XHExternalCompletionBlock
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable XHExternalCompletionBlock)completedBlock;

/**
 设置url图片

 @param url 图片url
 @param completedBlock XHExternalCompletionBlock
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url completed:(nullable XHExternalCompletionBlock)completedBlock;


/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param options JQLaunchAdImageOptions
 @param completedBlock XHExternalCompletionBlock
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(JQLaunchAdImageOptions)options completed:(nullable XHExternalCompletionBlock)completedBlock;

/**
 设置url图片

 @param url 图片url
 @param placeholder 占位图
 @param GIFImageCycleOnce gif是否只循环播放一次
 @param options JQLaunchAdImageOptions
 @param GIFImageCycleOnceFinish gif播放完回调(GIFImageCycleOnce = YES 有效)
 @param completedBlock XHExternalCompletionBlock
 */
- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder GIFImageCycleOnce:(BOOL)GIFImageCycleOnce options:(JQLaunchAdImageOptions)options GIFImageCycleOnceFinish:(void(^_Nullable)(void))cycleOnceFinishBlock completed:(nullable XHExternalCompletionBlock)completedBlock ;

@end
