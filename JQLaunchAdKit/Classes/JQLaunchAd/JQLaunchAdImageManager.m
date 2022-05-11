

#import "JQLaunchAdImageManager.h"
#import "JQLaunchAdCache.h"

@interface JQLaunchAdImageManager()

@property(nonatomic,strong) JQLaunchAdDownloader *downloader;
@end

@implementation JQLaunchAdImageManager

+(nonnull instancetype )sharedManager{
    static JQLaunchAdImageManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[JQLaunchAdImageManager alloc] init];
        
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _downloader = [JQLaunchAdDownloader sharedDownloader];
    }
    return self;
}

- (void)loadImageWithURL:(nullable NSURL *)url options:(JQLaunchAdImageOptions)options progress:(nullable JQLaunchAdDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock{
    if(!options) options = JQLaunchAdImageDefault;
    if(options & JQLaunchAdImageOnlyLoad){
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
        }];
    }else if (options & JQLaunchAdImageRefreshCached){
        NSData *imageData = [JQLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock) completedBlock(image,imageData,nil,url);
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
            [JQLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
        }];
    }else if (options & JQLaunchAdImageCacheInBackground){
        NSData *imageData = [JQLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                [JQLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }else{//default
        NSData *imageData = [JQLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if(completedBlock) completedBlock(image,data,error,url);
                [JQLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }
}

@end
