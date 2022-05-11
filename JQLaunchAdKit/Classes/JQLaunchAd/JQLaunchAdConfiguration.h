

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JQLaunchAdButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JQLaunchAdImageManager.h"
#import "JQLaunchAdConst.h"

NS_ASSUME_NONNULL_BEGIN

/** 显示完成动画时间默认时间 */
static CGFloat const showFinishAnimateTimeDefault = 0.8;

/** 显示完成动画类型 */
typedef NS_ENUM(NSInteger , ShowFinishAnimate) {
    /** 无动画 */
    ShowFinishAnimateNone = 1,
    /** 普通淡入(default) */
    ShowFinishAnimateFadein = 2,
    /** 放大淡入 */
    ShowFinishAnimateLite = 3,
    /** 左右翻转(类似网易云音乐) */
    ShowFinishAnimateFlipFromLeft = 4,
    /** 下上翻转 */
    ShowFinishAnimateFlipFromBottom = 5,
    /** 向上翻页 */
    ShowFinishAnimateCurlUp = 6,
};

#pragma mark - 公共属性
@interface JQLaunchAdConfiguration : NSObject

/** 停留时间(default 5 ,单位:秒) */
@property(nonatomic,assign)NSInteger duration;

/** 跳过按钮类型(default SkipTypeTimeText) */
@property(nonatomic,assign)SkipType skipButtonType;

/** 显示完成动画(default ShowFinishAnimateFadein) */
@property(nonatomic,assign)ShowFinishAnimate showFinishAnimate;

/** 显示完成动画时间(default 0.8 , 单位:秒) */
@property(nonatomic,assign)CGFloat showFinishAnimateTime;

/** 设置开屏广告的frame(default [UIScreen mainScreen].bounds) */
@property (nonatomic,assign) CGRect frame;

/** 程序从后台恢复时,是否需要展示广告(defailt NO) */
@property (nonatomic,assign) BOOL showEnterForeground;

/** 点击打开页面地址(请使用openModel,点击事件代理方法请对应使用JQLaunchAd:clickAndOpenModel:clickPoint:) */
@property(nonatomic,copy)NSString *openURLString JQLaunchAdDeprecated("请使用openModel,点击事件代理方法请对应使用JQLaunchAd:clickAndOpenModel:clickPoint:");

/** 点击打开页面参数 */
@property (nonatomic, strong) id openModel;

/** 自定义跳过按钮(若定义此视图,将会自定替换系统跳过按钮) */
@property(nonatomic,strong) UIView *customSkipView;

/** 子视图(若定义此属性,这些视图将会被自动添加在广告视图上,frame相对于window) */
@property(nonatomic,copy,nullable) NSArray<UIView *> *subViews;

@end

#pragma mark - 图片广告相关
@interface JQLaunchImageAdConfiguration : JQLaunchAdConfiguration

/** image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL string */
@property(nonatomic,copy)NSString *imageNameOrURLString;

/** 图片广告缩放模式(default UIViewContentModeScaleToFill) */
@property(nonatomic,assign)UIViewContentMode contentMode;

/** 缓存机制(default JQLaunchImageDefault) */
@property(nonatomic,assign)JQLaunchAdImageOptions imageOption;

/** 设置GIF动图是否只循环播放一次(YES:只播放一次,NO:循环播放,default NO,仅对动图设置有效) */
@property (nonatomic, assign) BOOL GIFImageCycleOnce;

+(JQLaunchImageAdConfiguration *)defaultConfiguration;

@end

#pragma mark - 视频广告相关
@interface JQLaunchVideoAdConfiguration : JQLaunchAdConfiguration

/** video本地名或网络链接URL string */
@property(nonatomic,copy)NSString *videoNameOrURLString;

/** 视频缩放模式(default MPMovieScalingModeAspectFill) */
@property(nonatomic,assign)MPMovieScalingMode scalingMode JQLaunchAdDeprecated("请使用videoGravity");

/** 视频缩放模式(default AVLayerVideoGravityResizeAspectFill) */
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

/** 设置视频是否只循环播放一次(YES:只播放一次,NO循环播放,default NO) */
@property (nonatomic, assign) BOOL videoCycleOnce;

/** 是否关闭音频(default NO) */
@property (nonatomic, assign) BOOL muted;

+(JQLaunchVideoAdConfiguration *)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
