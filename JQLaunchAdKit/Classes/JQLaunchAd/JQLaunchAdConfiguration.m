

#import "JQLaunchAdConfiguration.h"

#pragma mark - 公共
@implementation JQLaunchAdConfiguration

@end

#pragma mark - 图片广告相关
@implementation JQLaunchImageAdConfiguration

+(JQLaunchImageAdConfiguration *)defaultConfiguration{
    //配置广告数据
    JQLaunchImageAdConfiguration *configuration = [JQLaunchImageAdConfiguration new];
    //广告停留时间
    configuration.duration = 5;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    configuration.GIFImageCycleOnce = NO;
    //缓存机制
    configuration.imageOption = JQLaunchAdImageDefault;
    //图片填充模式
    configuration.contentMode = UIViewContentModeScaleToFill;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
     //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    configuration.showEnterForeground = NO;
    return configuration;
}

@end

#pragma mark - 视频广告相关
@implementation JQLaunchVideoAdConfiguration
+(JQLaunchVideoAdConfiguration *)defaultConfiguration{
    //配置广告数据
    JQLaunchVideoAdConfiguration *configuration = [JQLaunchVideoAdConfiguration new];
    //广告停留时间
    configuration.duration = 5;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    //视频填充模式
    configuration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //是否只循环播放一次
    configuration.videoCycleOnce = NO;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
    //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    configuration.showEnterForeground = NO;
    //是否静音播放
    configuration.muted = NO;
    return configuration;
}
@end
