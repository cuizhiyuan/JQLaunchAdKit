

#import "JQLaunchAd.h"
#import "JQLaunchAdView.h"
#import "JQLaunchAdImageView+JQLaunchAdCache.h"
#import "JQLaunchAdDownloader.h"
#import "JQLaunchAdCache.h"
#import "JQLaunchAdController.h"

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
    #import <FLAnimatedImage/FLAnimatedImage.h>
#else
    #import "FLAnimatedImage.h"
#endif

typedef NS_ENUM(NSInteger, JQLaunchAdType) {
    JQLaunchAdTypeImage,
    JQLaunchAdTypeVideo
};

static NSInteger defaultWaitDataDuration = 3;
static  SourceType _sourceType = SourceTypeLaunchImage;
@interface JQLaunchAd()

@property(nonatomic,assign)JQLaunchAdType launchAdType;
@property(nonatomic,assign)NSInteger waitDataDuration;
@property(nonatomic,strong)JQLaunchImageAdConfiguration * imageAdConfiguration;
@property(nonatomic,strong)JQLaunchVideoAdConfiguration * videoAdConfiguration;
@property(nonatomic,strong)JQLaunchAdButton * skipButton;
@property(nonatomic,strong)JQLaunchAdVideoView * adVideoView;
@property(nonatomic,strong)UIWindow * window;
@property(nonatomic,copy)dispatch_source_t waitDataTimer;
@property(nonatomic,copy)dispatch_source_t skipTimer;
@property (nonatomic, assign) BOOL detailPageShowing;
@property(nonatomic,assign) CGPoint clickPoint;
@end

@implementation JQLaunchAd
+(void)setLaunchSourceType:(SourceType)sourceType{
    _sourceType = sourceType;
}
+(void)setWaitDataDuration:(NSInteger )waitDataDuration{
    JQLaunchAd *launchAd = [JQLaunchAd shareLaunchAd];
    launchAd.waitDataDuration = waitDataDuration;
}
+(JQLaunchAd *)imageAdWithImageAdConfiguration:(JQLaunchImageAdConfiguration *)imageAdconfiguration{
    return [JQLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:nil];
}

+(JQLaunchAd *)imageAdWithImageAdConfiguration:(JQLaunchImageAdConfiguration *)imageAdconfiguration delegate:(id)delegate{
    JQLaunchAd *launchAd = [JQLaunchAd shareLaunchAd];
    if(delegate) launchAd.delegate = delegate;
    launchAd.imageAdConfiguration = imageAdconfiguration;
    return launchAd;
}

+(JQLaunchAd *)videoAdWithVideoAdConfiguration:(JQLaunchVideoAdConfiguration *)videoAdconfiguration{
    return [JQLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:nil];
}

+(JQLaunchAd *)videoAdWithVideoAdConfiguration:(JQLaunchVideoAdConfiguration *)videoAdconfiguration delegate:(nullable id)delegate{
    JQLaunchAd *launchAd = [JQLaunchAd shareLaunchAd];
    if(delegate) launchAd.delegate = delegate;
    launchAd.videoAdConfiguration = videoAdconfiguration;
    return launchAd;
}

+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadImageAndCacheWithURLArray:urlArray completed:nil];
}

+ (void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[JQLaunchAdDownloader sharedDownloader] downLoadImageAndCacheWithURLArray:urlArray completed:completedBlock];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadVideoAndCacheWithURLArray:urlArray completed:nil];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[JQLaunchAdDownloader sharedDownloader] downLoadVideoAndCacheWithURLArray:urlArray completed:completedBlock];
}
+(void)removeAndAnimated:(BOOL)animated{
    [[JQLaunchAd shareLaunchAd] removeAndAnimated:animated];
}

+(BOOL)checkImageInCacheWithURL:(NSURL *)url{
    return [JQLaunchAdCache checkImageInCacheWithURL:url];
}

+(BOOL)checkVideoInCacheWithURL:(NSURL *)url{
    return [JQLaunchAdCache checkVideoInCacheWithURL:url];
}
+(void)clearDiskCache{
    [JQLaunchAdCache clearDiskCache];
}

+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray{
    [JQLaunchAdCache clearDiskCacheWithImageUrlArray:imageUrlArray];
}

+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray{
    [JQLaunchAdCache clearDiskCacheExceptImageUrlArray:exceptImageUrlArray];
}

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
    [JQLaunchAdCache clearDiskCacheWithVideoUrlArray:videoUrlArray];
}

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
    [JQLaunchAdCache clearDiskCacheExceptVideoUrlArray:exceptVideoUrlArray];
}

+(float)diskCacheSize{
    return [JQLaunchAdCache diskCacheSize];
}

+(NSString *)JQLaunchAdCachePath{
    return [JQLaunchAdCache JQLaunchAdCachePath];
}

+(NSString *)cacheImageURLString{
    return [JQLaunchAdCache getCacheImageUrl];
}

+(NSString *)cacheVideoURLString{
    return [JQLaunchAdCache getCacheVideoUrl];
}

#pragma mark - 过期
/** 请使用removeAndAnimated: */
+(void)skipAction{
    [[JQLaunchAd shareLaunchAd] removeAndAnimated:YES];
}
/** 请使用setLaunchSourceType: */
+(void)setLaunchImagesSource:(LaunchImagesSource)launchImagesSource{
    switch (launchImagesSource) {
        case LaunchImagesSourceLaunchImage:
            _sourceType = SourceTypeLaunchImage;
            break;
        case LaunchImagesSourceLaunchScreen:
            _sourceType = SourceTypeLaunchScreen;
            break;
        default:
            break;
    }
}

#pragma mark - private
+(JQLaunchAd *)shareLaunchAd{
    static JQLaunchAd *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[JQLaunchAd alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        XHWeakSelf
        [self setupLaunchAd];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setupLaunchAdEnterForeground];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self removeOnly];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:JQLaunchAdDetailPageWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = YES;
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:JQLaunchAdDetailPageShowFinishNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.detailPageShowing = NO;
        }];
    }
    return self;
}

-(void)setupLaunchAdEnterForeground{
    switch (_launchAdType) {
        case JQLaunchAdTypeImage:{
            if(!_imageAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            [self setupImageAdForConfiguration:_imageAdConfiguration];
        }
            break;
        case JQLaunchAdTypeVideo:{
            if(!_videoAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            [self setupVideoAdForConfiguration:_videoAdConfiguration];
        }
            break;
        default:
            break;
    }
}

-(void)setupLaunchAd{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [JQLaunchAdController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    window.windowLevel = UIWindowLevelStatusBar + 1;
    window.hidden = NO;
    window.alpha = 1;
    _window = window;
    /** 添加launchImageView */
    [_window addSubview:[[JQLaunchImageView alloc] initWithSourceType:_sourceType]];
}

/**图片*/
-(void)setupImageAdForConfiguration:(JQLaunchImageAdConfiguration *)configuration{
    if(_window == nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    JQLaunchAdImageView *adImageView = [[JQLaunchAdImageView alloc] init];
    [_window addSubview:adImageView];
    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) adImageView.frame = configuration.frame;
    if(configuration.contentMode) adImageView.contentMode = configuration.contentMode;
    /** webImage */
    if(configuration.imageNameOrURLString.length && XHISURLString(configuration.imageNameOrURLString)){
        [JQLaunchAdCache async_saveImageUrl:configuration.imageNameOrURLString];
        /** 自设图片 */
        if ([self.delegate respondsToSelector:@selector(JQLaunchAd:launchAdImageView:URL:)]) {
            [self.delegate JQLaunchAd:self launchAdImageView:adImageView URL:[NSURL URLWithString:configuration.imageNameOrURLString]];
        }else{
            if(!configuration.imageOption) configuration.imageOption = JQLaunchAdImageDefault;
            XHWeakSelf
            [adImageView xh_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString] placeholderImage:nil GIFImageCycleOnce:configuration.GIFImageCycleOnce options:configuration.imageOption GIFImageCycleOnceFinish:^{
                //GIF不循环,播放完成
                [[NSNotificationCenter defaultCenter] postNotificationName:JQLaunchAdGIFImageCycleOnceFinishNotification object:nil userInfo:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                
            } completed:^(UIImage *image,NSData *imageData,NSError *error,NSURL *url){
                if(!error){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                    if ([weakSelf.delegate respondsToSelector:@selector(JQLaunchAd:imageDownLoadFinish:)]) {
                        [weakSelf.delegate JQLaunchAd:self imageDownLoadFinish:image];
                    }
#pragma clang diagnostic pop
                    if ([weakSelf.delegate respondsToSelector:@selector(JQLaunchAd:imageDownLoadFinish:imageData:)]) {
                        [weakSelf.delegate JQLaunchAd:self imageDownLoadFinish:image imageData:imageData];
                    }
                }
            }];
            if(configuration.imageOption == JQLaunchAdImageCacheInBackground){
                /** 缓存中未有 */
                if(![JQLaunchAdCache checkImageInCacheWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]]){
                    [self removeAndAnimateDefault]; return; /** 完成显示 */
                }
            }
        }
    }else{
        if(configuration.imageNameOrURLString.length){
            NSData *data = XHDataWithFileName(configuration.imageNameOrURLString);
            if(XHISGIFTypeWithData(data)){
                FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
                adImageView.animatedImage = image;
                adImageView.image = nil;
                __weak typeof(adImageView) w_adImageView = adImageView;
                adImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(configuration.GIFImageCycleOnce){
                        [w_adImageView stopAnimating];
                        JQLaunchAdLog(@"GIF不循环,播放完成");
                        [[NSNotificationCenter defaultCenter] postNotificationName:JQLaunchAdGIFImageCycleOnceFinishNotification object:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                    }
                };
            }else{
                adImageView.animatedImage = nil;
                adImageView.image = [UIImage imageWithData:data];
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            if ([self.delegate respondsToSelector:@selector(JQLaunchAd:imageDownLoadFinish:)]) {
                [self.delegate JQLaunchAd:self imageDownLoadFinish:[UIImage imageWithData:data]];
            }
#pragma clang diagnostic pop
        }else{
            JQLaunchAdLog(@"未设置广告图片");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    XHWeakSelf
    adImageView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

-(void)addSkipButtonForConfiguration:(JQLaunchAdConfiguration *)configuration{
    if(!configuration.duration) configuration.duration = 5;
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;
    if(configuration.customSkipView){
        [_window addSubview:configuration.customSkipView];
    }else{
        if(_skipButton == nil){
            _skipButton = [[JQLaunchAdButton alloc] initWithSkipType:configuration.skipButtonType];
            _skipButton.hidden = YES;
            [_skipButton addTarget:self action:@selector(skipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_window addSubview:_skipButton];
        [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:configuration.duration];
    }
}

/**视频*/
-(void)setupVideoAdForConfiguration:(JQLaunchVideoAdConfiguration *)configuration{
    if(_window ==nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    if(!_adVideoView){
        _adVideoView = [[JQLaunchAdVideoView alloc] init];
    }
    [_window addSubview:_adVideoView];
    /** frame */
    if(configuration.frame.size.width>0&&configuration.frame.size.height>0) _adVideoView.frame = configuration.frame;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if(configuration.scalingMode) _adVideoView.videoScalingMode = configuration.scalingMode;
#pragma clang diagnostic pop
    if(configuration.videoGravity) _adVideoView.videoGravity = configuration.videoGravity;
    _adVideoView.videoCycleOnce = configuration.videoCycleOnce;
    if(configuration.videoCycleOnce){
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            JQLaunchAdLog(@"video不循环,播放完成");
            [[NSNotificationCenter defaultCenter] postNotificationName:JQLaunchAdVideoCycleOnceFinishNotification object:nil userInfo:@{@"videoNameOrURLString":configuration.videoNameOrURLString}];
        }];
    }
    /** video 数据源 */
    if(configuration.videoNameOrURLString.length && XHISURLString(configuration.videoNameOrURLString)){
        [JQLaunchAdCache async_saveVideoUrl:configuration.videoNameOrURLString];
        NSURL *pathURL = [JQLaunchAdCache getCacheVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString]];
        if(pathURL){
            if ([self.delegate respondsToSelector:@selector(JQLaunchAd:videoDownLoadFinish:)]) {
                [self.delegate JQLaunchAd:self videoDownLoadFinish:pathURL];
            }
            _adVideoView.contentURL = pathURL;
            _adVideoView.muted = configuration.muted;
            [_adVideoView.videoPlayer.player play];
        }else{
            XHWeakSelf
            [[JQLaunchAdDownloader sharedDownloader] downloadVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString] progress:^(unsigned long long total, unsigned long long current) {
                if ([weakSelf.delegate respondsToSelector:@selector(JQLaunchAd:videoDownLoadProgress:total:current:)]) {
                    [weakSelf.delegate JQLaunchAd:self videoDownLoadProgress:current/(float)total total:total current:current];
                }
            }  completed:^(NSURL * _Nullable location, NSError * _Nullable error){
                if(!error){
                    if ([weakSelf.delegate respondsToSelector:@selector(JQLaunchAd:videoDownLoadFinish:)]){
                        [weakSelf.delegate JQLaunchAd:self videoDownLoadFinish:location];
                    }
                }
            }];
            /***视频缓存,提前显示完成 */
            [self removeAndAnimateDefault]; return;
        }
    }else{
        if(configuration.videoNameOrURLString.length){
            NSURL *pathURL = nil;
            NSURL *cachePathURL = [[NSURL alloc] initFileURLWithPath:[JQLaunchAdCache videoPathWithFileName:configuration.videoNameOrURLString]];
            //若本地视频未在沙盒缓存文件夹中
            if (![JQLaunchAdCache checkVideoInCacheWithFileName:configuration.videoNameOrURLString]) {
                /***如果不在沙盒文件夹中则将其复制一份到沙盒缓存文件夹中/下次直接取缓存文件夹文件,加快文件查找速度 */
                NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:configuration.videoNameOrURLString withExtension:nil];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] copyItemAtURL:bundleURL toURL:cachePathURL error:nil];
                });
                pathURL = bundleURL;
            }else{
                pathURL = cachePathURL;
            }
            
            if(pathURL){
                if ([self.delegate respondsToSelector:@selector(JQLaunchAd:videoDownLoadFinish:)]) {
                    [self.delegate JQLaunchAd:self videoDownLoadFinish:pathURL];
                }
                _adVideoView.contentURL = pathURL;
                _adVideoView.muted = configuration.muted;
                [_adVideoView.videoPlayer.player play];
                
            }else{
                JQLaunchAdLog(@"Error:广告视频未找到,请检查名称是否有误!");
            }
        }else{
            JQLaunchAdLog(@"未设置广告视频");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0) [self addSubViews:configuration.subViews];
    XHWeakSelf
    _adVideoView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

#pragma mark - add subViews
-(void)addSubViews:(NSArray *)subViews{
    [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [_window addSubview:view];
    }];
}

#pragma mark - set
-(void)setImageAdConfiguration:(JQLaunchImageAdConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    _launchAdType = JQLaunchAdTypeImage;
    [self setupImageAdForConfiguration:imageAdConfiguration];
}

-(void)setVideoAdConfiguration:(JQLaunchVideoAdConfiguration *)videoAdConfiguration{
    _videoAdConfiguration = videoAdConfiguration;
    _launchAdType = JQLaunchAdTypeVideo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupVideoAdForConfiguration:videoAdConfiguration];
    });
}

-(void)setWaitDataDuration:(NSInteger)waitDataDuration{
    _waitDataDuration = waitDataDuration;
    /** 数据等待 */
    [self startWaitDataDispathTiemr];
}

#pragma mark - Action
-(void)skipButtonClick:(JQLaunchAdButton *)button{
    if ([self.delegate respondsToSelector:@selector(JQLaunchAd:clickSkipButton:)]) {
        [self.delegate JQLaunchAd:self clickSkipButton:button];
    }
    [self removeAndAnimated:YES];
}

-(void)removeAndAnimated:(BOOL)animated{
    if(animated){
        [self removeAndAnimate];
    }else{
        [self remove];
    }
}

-(void)clickAndPoint:(CGPoint)point{
    self.clickPoint = point;
    JQLaunchAdConfiguration * configuration = [self commonConfiguration];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(JQLaunchAd:clickAndOpenURLString:)]) {
        [self.delegate JQLaunchAd:self clickAndOpenURLString:configuration.openURLString];
        [self removeAndAnimateDefault];
    }
    if ([self.delegate respondsToSelector:@selector(JQLaunchAd:clickAndOpenURLString:clickPoint:)]) {
        [self.delegate JQLaunchAd:self clickAndOpenURLString:configuration.openURLString clickPoint:point];
        [self removeAndAnimateDefault];
    }
    if ([self.delegate respondsToSelector:@selector(JQLaunchAd:clickAndOpenModel:clickPoint:)]) {
        [self.delegate JQLaunchAd:self clickAndOpenModel:configuration.openModel clickPoint:point];
        [self removeAndAnimateDefault];
    }
#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(JQLaunchAd:clickAtOpenModel:clickPoint:)]) {
        BOOL status =  [self.delegate JQLaunchAd:self clickAtOpenModel:configuration.openModel clickPoint:point];
        if(status) [self removeAndAnimateDefault];
    }
}

-(JQLaunchAdConfiguration *)commonConfiguration{
    JQLaunchAdConfiguration *configuration = nil;
    switch (_launchAdType) {
        case JQLaunchAdTypeVideo:
            configuration = _videoAdConfiguration;
            break;
        case JQLaunchAdTypeImage:
            configuration = _imageAdConfiguration;
            break;
        default:
            break;
    }
    return configuration;
}

-(void)startWaitDataDispathTiemr{
    __block NSInteger duration = defaultWaitDataDuration;
    if(_waitDataDuration) duration = _waitDataDuration;
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_waitDataTimer, ^{
        if(duration==0){
            DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:JQLaunchAdWaitDataDurationArriveNotification object:nil];
                [self remove];
                return ;
            });
        }
        duration--;
    });
    dispatch_resume(_waitDataTimer);
}

-(void)startSkipDispathTimer{
    JQLaunchAdConfiguration * configuration = [self commonConfiguration];
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;//默认
    __block NSInteger duration = 5;//默认
    if(configuration.duration) duration = configuration.duration;
    if(configuration.skipButtonType == SkipTypeRoundProgressTime || configuration.skipButtonType == SkipTypeRoundProgressText){
        [_skipButton startRoundDispathTimerWithDuration:duration];
    }
    NSTimeInterval period = 1.0;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(JQLaunchAd:customSkipView:duration:)]) {
                [self.delegate JQLaunchAd:self customSkipView:configuration.customSkipView duration:duration];
            }
            if(!configuration.customSkipView){
                [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:duration];
            }
            if(duration==0){
                DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer);
                [self removeAndAnimate]; return ;
            }
            duration--;
        });
    });
    dispatch_resume(_skipTimer);
}

-(void)removeAndAnimate{
    JQLaunchAdConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    switch (configuration.showFinishAnimate) {
        case ShowFinishAnimateNone:{
            [self remove];
        }
            break;
        case ShowFinishAnimateFadein:{
            [self removeAndAnimateDefault];
        }
            break;
        case ShowFinishAnimateLite:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                _window.transform = CGAffineTransformMakeScale(1.5, 1.5);
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromLeft:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromBottom:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateCurlUp:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        default:{
            [self removeAndAnimateDefault];
        }
            break;
    }
}

-(void)removeAndAnimateDefault{
    JQLaunchAdConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionNone animations:^{
        _window.alpha = 0;
    } completion:^(BOOL finished) {
        [self remove];
    }];
}
-(void)removeOnly{
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer)
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer)
    REMOVE_FROM_SUPERVIEW_SAFE(_skipButton)
    if(_launchAdType==JQLaunchAdTypeVideo){
        if(_adVideoView){
            [_adVideoView stopVideoPlayer];
            REMOVE_FROM_SUPERVIEW_SAFE(_adVideoView)
        }
    }
    if(_window){
        [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }];
        _window.hidden = YES;
        _window = nil;
    }
}

-(void)remove{
    [self removeOnly];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(JQLaunchShowFinish:)]) {
        [self.delegate JQLaunchShowFinish:self];
    }
#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(JQLaunchAdShowFinish:)]) {
        [self.delegate JQLaunchAdShowFinish:self];
    }
}

-(void)removeSubViewsExceptLaunchAdImageView{
    [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[JQLaunchImageView class]]){
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
