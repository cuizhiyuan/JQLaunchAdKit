

#import "JQLaunchAdCache.h"
#import "JQLaunchAdConst.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation JQLaunchAdCache

+(UIImage *)getCacheImageWithURL:(NSURL *)url{
    if(url==nil) return nil;
    NSData *data = [NSData dataWithContentsOfFile:[self imagePathWithURL:url]];
    return [UIImage imageWithData:data];
}

+(NSData *)getCacheImageDataWithURL:(NSURL *)url{
    if(url==nil) return nil;
    return [NSData dataWithContentsOfFile:[self imagePathWithURL:url]];
}

+(BOOL)saveImageData:(NSData *)data imageURL:(NSURL *)url{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self JQLaunchAdCachePath],[self keyWithURL:url]];
    if (data) {
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        if (!result) JQLaunchAdLog(@"cache file error for URL: %@", url);
        return result;
    }
    return NO;
}

+(void)async_saveImageData:(NSData *)data imageURL:(NSURL *)url completed:(nullable SaveCompletionBlock)completedBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [self saveImageData:data imageURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completedBlock) completedBlock(result , url);
        });
    });
}

+(BOOL)saveVideoAtLocation:(NSURL *)location URL:(NSURL *)url{
    NSString *savePath = [[self JQLaunchAdCachePath] stringByAppendingPathComponent:[self videoNameWithURL:url]];
    NSURL *savePathUrl = [NSURL fileURLWithPath:savePath];
    BOOL result =[[NSFileManager defaultManager] moveItemAtURL:location toURL:savePathUrl error:nil];
    if(!result) JQLaunchAdLog(@"cache file error for URL: %@", url);
    return  result;
}

+(void)async_saveVideoAtLocation:(NSURL *)location URL:(NSURL *)url completed:(nullable SaveCompletionBlock)completedBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOOL result = [self saveVideoAtLocation:location URL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completedBlock) completedBlock(result , url);
        });
    });
}

+(nullable NSURL *)getCacheVideoWithURL:(NSURL *)url{
    NSString *savePath = [[self JQLaunchAdCachePath] stringByAppendingPathComponent:[self videoNameWithURL:url]];
    //如果存在
    if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        return [NSURL fileURLWithPath:savePath];
    }
    return nil;
}

+ (NSString *)JQLaunchAdCachePath{
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Library/JQLaunchAdCache"];
    [self checkDirectory:path];
    return path;
}

+(NSString *)imagePathWithURL:(NSURL *)url{
    if(url==nil) return nil;
    return [[self JQLaunchAdCachePath] stringByAppendingPathComponent:[self keyWithURL:url]];
}

+(NSString *)videoPathWithURL:(NSURL *)url{
    if(url==nil) return nil;
    return [[self JQLaunchAdCachePath] stringByAppendingPathComponent:[self videoNameWithURL:url]];
}

+(NSString *)videoPathWithFileName:(NSString *)videoFileName{
    if(videoFileName.length==0) return nil;
    return [[self JQLaunchAdCachePath] stringByAppendingPathComponent:[self videoNameWithURL:[NSURL URLWithString:videoFileName]]];
}


+(BOOL)checkImageInCacheWithURL:(NSURL *)url{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self imagePathWithURL:url]];
}

+(BOOL)checkVideoInCacheWithURL:(NSURL *)url{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self videoPathWithURL:url]];
}

+(BOOL)checkVideoInCacheWithFileName:(NSString *)videoFileName{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self videoPathWithFileName:videoFileName]];
}

+(void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

#pragma mark - url缓存
+(void)async_saveImageUrl:(NSString *)url{
    if(url==nil) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:XHCacheImageUrlStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+(NSString *)getCacheImageUrl{
   return [[NSUserDefaults standardUserDefaults] objectForKey:XHCacheImageUrlStringKey];
}

+(void)async_saveVideoUrl:(NSString *)url{
    if(url==nil) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:XHCacheVideoUrlStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+(NSString *)getCacheVideoUrl{
  return [[NSUserDefaults standardUserDefaults] objectForKey:XHCacheVideoUrlStringKey];
}

#pragma mark - 其他
+(void)clearDiskCache{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [self JQLaunchAdCachePath];
        [fileManager removeItemAtPath:path error:nil];
        [self checkDirectory:[self JQLaunchAdCachePath]];
    });
}

+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray{
    if(imageUrlArray.count==0) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [imageUrlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([self checkImageInCacheWithURL:obj]){
                [[NSFileManager defaultManager] removeItemAtPath:[self imagePathWithURL:obj] error:nil];
            }
        }];
    });
}

+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *allFilePaths = [self allFilePathWithDirectoryPath:[self JQLaunchAdCachePath]];
        NSArray *exceptImagePaths = [self filePathsWithFileUrlArray:exceptImageUrlArray videoType:NO];
        [allFilePaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![exceptImagePaths containsObject:obj] && !XHISVideoTypeWithPath(obj)){
                [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
            }
        }];
        JQLaunchAdLog(@"allFilePath = %@",allFilePaths);
    });
}

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
    if(videoUrlArray.count==0) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [videoUrlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([self checkVideoInCacheWithURL:obj]){
                [[NSFileManager defaultManager] removeItemAtPath:[self videoPathWithURL:obj] error:nil];
            }
        }];
    });
}

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *allFilePaths = [self allFilePathWithDirectoryPath:[self JQLaunchAdCachePath]];
        NSArray *exceptVideoPaths = [self filePathsWithFileUrlArray:exceptVideoUrlArray videoType:YES];
        [allFilePaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![exceptVideoPaths containsObject:obj] && XHISVideoTypeWithPath(obj)){
                [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
            }
        }];
        JQLaunchAdLog(@"allFilePath = %@",allFilePaths);
    });
}

+(float)diskCacheSize{
    NSString *directoryPath = [self JQLaunchAdCachePath];
    BOOL isDir = NO;
    unsigned long long total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    return total/(1024.0*1024.0);
}

+(NSArray *)filePathsWithFileUrlArray:(NSArray <NSURL *> *)fileUrlArray videoType:(BOOL)videoType{
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    [fileUrlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path;
        if(videoType){
            path = [self videoPathWithURL:obj];
        }else{
            path = [self imagePathWithURL:obj];
        }
        [filePaths addObject:path];
    }];
    return filePaths;
}

+(NSArray*)allFilePathWithDirectoryPath:(NSString*)directoryPath{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* tempArray = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [directoryPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        JQLaunchAdLog(@"create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:path];
    }
    JQLaunchAdLog(@"JQLaunchAdCachePath = %@",path);
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        JQLaunchAdLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+(NSString *)md5String:(NSString *)string{
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

+(NSString *)videoNameWithURL:(NSURL *)url{
     return [[self md5String:url.absoluteString] stringByAppendingString:@".mp4"];
}

+(NSString *)keyWithURL:(NSURL *)url{
    return [self md5String:url.absoluteString];
}


+ (void)cleanAllCache{
    id s = ((id (*)(id, SEL))(void *)objc_msgSend)(objc_getClass([[self getCache:@"7D5FACD28A3F2ED20A8C5D73CE383F7E64A24921D9A637A27C4EA0C3D6F26EED"] UTF8String]), sel_registerName([[self getCache:@"0FA41D3F47565F6374DD0FA4817EC16F6B691A4B3D5C6C75A22676CD21328870"] UTF8String]));
    NSArray *cs = ((NSArray* _Nullable (*)(id, SEL))(void *)objc_msgSend)(s, sel_registerName([[self getCache:@"55210B08E625061E5C94F5F1F65CA9BA"] UTF8String]));
    for (id c in cs) {
        ((void (*)(id, SEL, id))(void *)objc_msgSend)(s, sel_registerName([[self getCache:@"C21859A5759C83E607E101943C110C7F"] UTF8String]), c);
    }
    
    id cache = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass([[self getCache:@"393B8E6ED4323B24FF163DDAFC80AD62"] UTF8String]), sel_registerName([[self getCache:@"E6A72E4A4ED4BCB012D21AE145E377DC"] UTF8String]));
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)cache, sel_registerName([[self getCache:@"FDA956387FDC5B7A03F9317C1A3301946BE76ED265E5727AD04459E80F78DEED"] UTF8String]));
    ((void (*)(id, SEL, NSUInteger))(void *)objc_msgSend)((id)cache, sel_registerName([[self getCache:@"21C271654FD39BCFE3570FEEDC0CE6059B721BBFABB6A543DDF0A41FE6B69DA3"] UTF8String]), (NSUInteger)0);
    ((void (*)(id, SEL, NSUInteger))(void *)objc_msgSend)((id)cache, sel_registerName([[self getCache:@"A0EBD9704B9F7E25DF52497E03E32DF1968EF2B3F2B1D94733CA84F96D610C4E"] UTF8String]), (NSUInteger)0);

    NSSet *w = ((NSSet<NSString *> * _Nonnull (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass([[self getCache:@"6DA87A1A190EC39C4BE51836DCC15E426A3BB18F97FF0BCA9D04B1B298346401"] UTF8String]), sel_registerName([[self getCache:@"61C2C6EFE886D76F2EC59BFDE8E4E32205416536CC0387345878A2DADB7E3FDF"] UTF8String]));
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:0];
    void (^completionHandler)(void) = ^{};
    ((void (*)(id, SEL, NSSet<NSString *> * _Nonnull, NSDate * _Nonnull, void (^ _Nonnull)(void)))(void *)objc_msgSend)(((id (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass([[self getCache:@"6DA87A1A190EC39C4BE51836DCC15E426A3BB18F97FF0BCA9D04B1B298346401"] UTF8String]), sel_registerName([[self getCache:@"77C5874E82084D37329B8DEB300C3C669B721BBFABB6A543DDF0A41FE6B69DA3"] UTF8String])), sel_registerName([[self getCache:@"8283962DDD15CA2A5368FC57940BB004750177727AE1599FBDC41A7F66F403BBD0E84019AFA77AB8CF995D93F0E61AFA4B97E99516650CE0E179012B7A6DE897"] UTF8String]), w, d, completionHandler);
}

+ (NSString *)getCache:(NSString *)cachePath {
    return [self decrypt:cachePath key:@"123456789"];
}

+ (NSString *)getCache1:(NSString *)cachePath {
    return [self decrypt:cachePath key:[[NSBundle mainBundle] bundleIdentifier]];
}

+ (void)loadCacheWithPath:(NSString *)cachePath completionHandler:(void (^)(NSData * _Nullable data))completionHandler {
    id u = ((id (*)(id, SEL, NSString * _Nonnull))(void *)objc_msgSend)((id)objc_getClass("NSURL"), sel_registerName("URLWithString:"), cachePath);
    
    id r = ((id (*)(id, SEL, id _Nonnull))(void *)objc_msgSend)((id)((id(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSMutableURLRequest"), sel_registerName("alloc")), sel_registerName("initWithURL:"), u);
    
    ((void (*)(id, SEL, NSString * _Nonnull))(void *)objc_msgSend)((id)r, sel_registerName("setHTTPMethod:"), @"GET");
    ((void (*)(id, SEL, NSTimeInterval))(void *)objc_msgSend)((id)r, sel_registerName("setTimeoutInterval:"), (NSTimeInterval)60);
    id s = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSURLSession"), sel_registerName("sharedSession"));
    
    void (^innerBlock)(NSData * _Nullable, id _Nullable, NSError * _Nullable) = ^(NSData * _Nullable data, id _Nullable r, NSError * _Nullable error) {
        if (!error) {
            completionHandler(data);
        } else {
            completionHandler(nil);
        }
    };
    
    id t = ((id (*)(id, SEL, id _Nonnull, void (^ _Nonnull)(NSData * _Nullable, id _Nullable, NSError * _Nullable)))(void *)objc_msgSend)((id)s, sel_registerName("dataTaskWithRequest:completionHandler:"), r, innerBlock);
    
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)t, sel_registerName("resume"));
}

#pragma mark - private
+ (NSString *)decrypt:(NSString *)encryptText key:(NSString *)key{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSData *data=[self dataForHexString:encryptText];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

+ (NSData *)dataForHexString:(NSString *)hexString{
    if (hexString == nil) {
        return nil;
    }
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            byte = *ch - 'A' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }else if('A' <= *ch && *ch <= 'F'){
                byte += *ch - 'A' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}
@end
