

#import "JQLaunchImageView.h"
#import "JQLaunchAdConst.h"


@interface JQLaunchImageView ()

@end

@implementation JQLaunchImageView
#pragma mark - private
- (instancetype)initWithSourceType:(SourceType)sourceType{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        switch (sourceType) {
            case SourceTypeLaunchImage:{
                self.image = [self imageFromLaunchImage];
            }
                break;
            case SourceTypeLaunchScreen:{
                self.image = [self imageFromLaunchScreen];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

-(UIImage *)imageFromLaunchImage{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL)  return imageL;
    JQLaunchAdLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

-(UIImage *)imageFromLaunchScreen{
    NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    if(UILaunchStoryboardName == nil){
        JQLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
        return nil;
    }
    UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
    if(LaunchScreenSb){
        UIView * view = LaunchScreenSb.view;
        // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
        UIWindow *containerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.frame = containerWindow.bounds;
        [containerWindow addSubview:view];
        [containerWindow layoutIfNeeded];
        UIImage *image = [self imageFromView:view];
        containerWindow = nil;
        return image;
    }
    JQLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
    return nil;
}

-(UIImage*)imageFromView:(UIView*)view{
    //fix bug:https://github.com/CoderZhuXH/JQLaunchAd/issues/203
    if (CGRectIsEmpty(view.frame)) {
        return nil;
    }
    CGSize size = view.bounds.size;
    //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage *)launchImageWithType:(NSString *)type{
    //比对分辨率,获取启动图 fix #158:https://github.com/CoderZhuXH/JQLaunchAd/issues/158
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screenDipSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * screenScale, [UIScreen mainScreen].bounds.size.height * screenScale);
    NSString *viewOrientation = type;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        UIImage *image = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        CGSize imageDpiSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
                imageDpiSize = CGSizeMake(imageDpiSize.height, imageDpiSize.width);
            }
            if(CGSizeEqualToSize(screenDipSize, imageDpiSize)){
                return image;
            }
        }
    }
    return nil;
}

@end
