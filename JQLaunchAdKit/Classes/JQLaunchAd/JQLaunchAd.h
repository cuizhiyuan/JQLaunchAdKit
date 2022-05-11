

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JQLaunchAdConfiguration.h"
#import "JQLaunchAdConst.h"
#import "JQLaunchImageView.h"

NS_ASSUME_NONNULL_BEGIN
@class JQLaunchAd;
@protocol JQLaunchAdDelegate <NSObject>
@optional

/**
广告点击回调

@param launchAd launchAd
@param openModel 打开页面参数(此参数即你配置广告数据设置的configuration.openModel)
@param clickPoint 点击位置
@return return  YES移除广告,NO不移除
*/
- (BOOL)JQLaunchAd:(JQLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint;

/**
 跳过按钮点击回调(注意:自定义跳过按钮不会走此回调)

 @param launchAd launchAd
 @param skipButton 跳过按钮
 */
- (void)JQLaunchAd:(JQLaunchAd *)launchAd clickSkipButton:(UIButton *)skipButton;

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  JQLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)JQLaunchAd:(JQLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData;

/**
 *  video本地读取/或下载完成回调
 *
 *  @param launchAd JQLaunchAd
 *  @param pathURL  本地保存路径
 */
-(void)JQLaunchAd:(JQLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL;

/**
 视频下载进度回调

 @param launchAd JQLaunchAd
 @param progress 下载进度
 @param total    总大小
 @param current  当前已下载大小
 */
-(void)JQLaunchAd:(JQLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current;

/**
 *  倒计时回调
 *
 *  @param launchAd JQLaunchAd
 *  @param duration 倒计时时间
 */
-(void)JQLaunchAd:(JQLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration;

/**
  广告显示完成

 @param launchAd JQLaunchAd
 */
-(void)JQLaunchAdShowFinish:(JQLaunchAd *)launchAd;

/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理,注意:实现此方法后,图片缓存将不受JQLaunchAd管理

 @param launchAd          JQLaunchAd
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
-(void)JQLaunchAd:(JQLaunchAd *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url;


#pragma mark - 过期-JQLaunchAdDelegate
- (void)JQLaunchAd:(JQLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint JQLaunchAdDeprecated("请使用JQLaunchAd:clickAtOpenModel:clickPoint:");
- (void)JQLaunchAd:(JQLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString JQLaunchAdDeprecated("请使用JQLaunchAd:clickAtOpenModel:clickPoint:");
- (void)JQLaunchAd:(JQLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString clickPoint:(CGPoint)clickPoint JQLaunchAdDeprecated("请使用JQLaunchAd:clickAtOpenModel:clickPoint:");
-(void)JQLaunchAd:(JQLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image JQLaunchAdDeprecated("请使用JQLaunchAd:imageDownLoadFinish:imageData:");
-(void)JQLaunchShowFinish:(JQLaunchAd *)launchAd JQLaunchAdDeprecated("请使用JQLaunchAdShowFinish:");

@end

@interface JQLaunchAd : NSObject
@property(nonatomic,assign) id<JQLaunchAdDelegate> delegate;

/**
 设置你工程的启动页使用的是LaunchImage还是LaunchScreen(default:SourceTypeLaunchImage)
 注意:请在设置等待数据及配置广告数据前调用此方法
 @param sourceType sourceType
 */
+(void)setLaunchSourceType:(SourceType)sourceType;

/**
 *  设置等待数据源时间(建议值:2)
 *
 *  @param waitDataDuration waitDataDuration
 */
+(void)setWaitDataDuration:(NSInteger )waitDataDuration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *
 *  @return JQLaunchAd
 */
+(JQLaunchAd *)imageAdWithImageAdConfiguration:(JQLaunchImageAdConfiguration *)imageAdconfiguration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *  @param delegate             delegate
 *
 *  @return JQLaunchAd
 */
+(JQLaunchAd *)imageAdWithImageAdConfiguration:(JQLaunchImageAdConfiguration *)imageAdconfiguration delegate:(nullable id)delegate;

/**
 *  视频开屏广告数据配置
 *
 *  @param videoAdconfiguration 数据配置
 *
 *  @return JQLaunchAd
 */
+(JQLaunchAd *)videoAdWithVideoAdConfiguration:(JQLaunchVideoAdConfiguration *)videoAdconfiguration;

/**
 *  视频开屏广告数据配置
 *
 *  @param videoAdconfiguration 数据配置
 *  @param delegate             delegate
 *
 *  @return JQLaunchAd
 */
+(JQLaunchAd *)videoAdWithVideoAdConfiguration:(JQLaunchVideoAdConfiguration *)videoAdconfiguration delegate:(nullable id)delegate;

#pragma mark -批量下载并缓存
/**
 *  批量下载并缓存image(异步) - 已缓存的image不会再次下载缓存
 *
 *  @param urlArray image URL Array
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;

/**
 批量下载并缓存image,并回调结果(异步)- 已缓存的image不会再次下载缓存

 @param urlArray image URL Array
 @param completedBlock 回调结果为一个字典数组,url:图片的url字符串,result:0表示该图片下载缓存失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

/**
 *  批量下载并缓存视频(异步) - 已缓存的视频不会再次下载缓存
 *
 *  @param urlArray 视频URL Array
 */
+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;

/**
 批量下载并缓存视频,并回调结果(异步) - 已缓存的视频不会再次下载缓存
 
 @param urlArray 视频URL Array
 @param completedBlock 回调结果为一个字典数组,url:视频的url字符串,result:0表示该视频下载缓存失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
 */
+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

#pragma mark - Action

/**
 手动移除广告

 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated;

#pragma mark - 是否已缓存
/**
 *  是否已缓存在该图片
 *
 *  @param url image url
 *
 *  @return BOOL
 */
+(BOOL)checkImageInCacheWithURL:(NSURL *)url;

/**
 *  是否已缓存该视频
 *
 *  @param url video url
 *
 *  @return BOOL
 */
+(BOOL)checkVideoInCacheWithURL:(NSURL *)url;

#pragma mark - 获取缓存url
/**
 从缓存中获取上一次的ImageURLString(JQLaunchAd 会默认缓存imageURLString)
 
 @return imageUrlString
 */
+(NSString *)cacheImageURLString;

/**
 从缓存中获取上一次的videoURLString(JQLaunchAd 会默认缓存VideoURLString)
 
 @return videoUrlString
 */
+(NSString *)cacheVideoURLString;

#pragma mark - 缓存/清理相关
/**
 *  清除JQLaunchAd本地所有缓存(异步)
 */
+(void)clearDiskCache;

/**
 清除指定Url的图片本地缓存(异步)

 @param imageUrlArray 需要清除缓存的图片Url数组
 */
+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray;

/**
 清除指定Url除外的图片本地缓存(异步)
 
 @param exceptImageUrlArray 此url数组的图片缓存将被保留
 */
+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray;

/**
 清除指定Url的视频本地缓存(异步)

 @param videoUrlArray 需要清除缓存的视频url数组
 */
+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray;

/**
 清除指定Url除外的视频本地缓存(异步)
 
 @param exceptVideoUrlArray 此url数组的视频缓存将被保留
 */
+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray;

/**
 *  获取JQLaunch本地缓存大小(M)
 */
+(float)diskCacheSize;

/**
 *  缓存路径
 */
+(NSString *)JQLaunchAdCachePath;

#pragma mark - 过期
+(void)skipAction JQLaunchAdDeprecated("请使用removeAndAnimated:");
+(void)setLaunchImagesSource:(LaunchImagesSource)launchImagesSource JQLaunchAdDeprecated("请使用setLaunchSourceType:");

@end
NS_ASSUME_NONNULL_END
