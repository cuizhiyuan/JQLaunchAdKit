

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - JQLaunchAdDownload

typedef void(^JQLaunchAdDownloadProgressBlock)(unsigned long long total, unsigned long long current);

typedef void(^JQLaunchAdDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData * _Nullable data, NSError * _Nullable error);

typedef void(^JQLaunchAdDownloadVideoCompletedBlock)(NSURL * _Nullable location, NSError * _Nullable error);

typedef void(^JQLaunchAdBatchDownLoadAndCacheCompletedBlock) (NSArray * _Nonnull completedArray);

@protocol JQLaunchAdDownloadDelegate <NSObject>

- (void)downloadFinishWithURL:(nonnull NSURL *)url;

@end

@interface JQLaunchAdDownload : NSObject
@property (assign, nonatomic ,nonnull)id<JQLaunchAdDownloadDelegate> delegate;
@end

@interface JQLaunchAdImageDownload : JQLaunchAdDownload

@end

@interface JQLaunchAdVideoDownload : JQLaunchAdDownload

@end

#pragma mark - JQLaunchAdDownloader
@interface JQLaunchAdDownloader : NSObject

+(nonnull instancetype )sharedDownloader;

- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable JQLaunchAdDownloadProgressBlock)progressBlock completed:(nullable JQLaunchAdDownloadImageCompletedBlock)completedBlock;

- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

- (void)downloadVideoWithURL:(nonnull NSURL *)url progress:(nullable JQLaunchAdDownloadProgressBlock)progressBlock completed:(nullable JQLaunchAdDownloadVideoCompletedBlock)completedBlock;

- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable JQLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

@end

