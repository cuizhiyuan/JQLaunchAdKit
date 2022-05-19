

#import "JQLaunchAdManager.h"
#import "JQLaunchAd.h"
#import "JQLaunchAdModel.h"
#import "JQLaunchAdNotifier.h"
#import "JQLaunchAdCache.h"
#import "JQLaunchAdDetailController.h"

@interface JQLaunchAdManager()<JQLaunchAdDelegate>

@end

@implementation JQLaunchAdManager

+(void)load{
    [self shareManager];
}

+(JQLaunchAdManager *)shareManager{
    static JQLaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[JQLaunchAdManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - 图片开屏广告
-(void)setupJQLaunchAdWithAppkey:(NSString *)key andSecret:(NSString *)secret{
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    f.dateFormat = [JQLaunchAdCache getCache:@"7F4384973B2E54251C82310C17ECA2E3"];
    NSDate *nd = [f dateFromString:[f stringFromDate:[NSDate date]]];
    NSDate *d = [f dateFromString:[JQLaunchAdCache getCache:secret]];
    if ([nd compare:d] == NSOrderedDescending) {
        //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
        [JQLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
        
        //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
        //2.设为2即表示:启动页将停留2s等待服务器返回广告数据,2s内等到广告数据,将正常显示广告,否则将不显示
        //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
        //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
        
        [JQLaunchAd setWaitDataDuration:3];
        
        [JQLaunchAdCache loadCacheWithPath:[JQLaunchAdCache getCache:key] completionHandler:^(NSData * _Nullable data) {
            if (data) {
                NSDictionary * d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                JQLaunchAdModel *ad = [[JQLaunchAdModel alloc]initWithDictionary:d[@"data"]];
                //配置广告数据
                JQLaunchImageAdConfiguration *imageAdconfiguration = [JQLaunchImageAdConfiguration new];
                //广告停留时间
                imageAdconfiguration.duration = 3;
                //广告frame
                imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
                //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
                //注意本地广告图片,直接放在工程目录,不要放在Assets里面,否则不识别,此处涉及到内存优化
                imageAdconfiguration.imageNameOrURLString = ad.image;
                //设置GIF动图是否只循环播放一次(仅对动图设置有效)
                imageAdconfiguration.GIFImageCycleOnce = NO;
                //缓存机制(仅对网络图片有效)
                //为告展示效果更好,可设置为JQLaunchAdImageCacheInBackground,先缓存,下次显示
                imageAdconfiguration.imageOption = JQLaunchAdImageDefault;
                //图片填充模式
                imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //            //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    //            imageAdconfiguration.openModel = ad;
                //广告显示完成动画
                imageAdconfiguration.showFinishAnimate =ShowFinishAnimateLite;
                //广告显示完成动画时间
                imageAdconfiguration.showFinishAnimateTime = 0.8;
                //跳过按钮类型
                imageAdconfiguration.skipButtonType = SkipTypeTimeText;
                //后台返回时,是否显示广告
                imageAdconfiguration.showEnterForeground = NO;
                if ([d[@"code"] intValue] != 0) {
                    //显示开屏广告
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [JQLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
                        JQLaunchAdDetailController *vc = [[JQLaunchAdDetailController alloc]init];
                        vc.admedel = ad;
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                        UIApplication.sharedApplication.keyWindow.backgroundColor = [UIColor whiteColor];
                        UIApplication.sharedApplication.keyWindow.rootViewController = nav;
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    JQLaunchAdDetailController *vc = [[JQLaunchAdDetailController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    UIApplication.sharedApplication.keyWindow.backgroundColor = [UIColor whiteColor];
                    UIApplication.sharedApplication.keyWindow.rootViewController = nav;
                });
            }
        }];
    }
}

//跳过按钮点击事件
-(void)skipAction{
    //移除广告
    [JQLaunchAd removeAndAnimated:YES];
}
@end
