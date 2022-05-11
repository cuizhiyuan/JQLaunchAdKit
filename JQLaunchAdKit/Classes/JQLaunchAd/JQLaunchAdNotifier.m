
#import "JQLaunchAdNotifier.h"
 
@interface AdDisconnectView : UIView

@end

@implementation AdDisconnectView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f];
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"NoNet"];
    [self addSubview:iv];

    [iv setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *m = [NSLayoutConstraint constraintWithItem:iv attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:iv attribute:(NSLayoutAttributeWidth) multiplier:1 constant:0];
    NSLayoutConstraint *cx = [NSLayoutConstraint constraintWithItem:iv attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    NSLayoutConstraint *cy = [NSLayoutConstraint constraintWithItem:iv attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0];
    NSLayoutConstraint *w = [NSLayoutConstraint constraintWithItem:iv attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeWidth) multiplier:1 constant:0];
    [self addConstraints:@[cx, cy, w, m]];
}
@end

@interface JQLaunchAdNotifier()
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic, strong) AdDisconnectView *d;
@property (nonatomic, copy) HandleBlcok handleBlock;

@end

@implementation JQLaunchAdNotifier
+ (JQLaunchAdNotifier *)shareAdNotifier{
    static JQLaunchAdNotifier *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[JQLaunchAdNotifier alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *remoteHostName = @"www.baidu.com";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self setUpViews];
    }
    return self;
}

-(void)startNotifierWithHandler:(void (^)(NetworkStatus))handleBlcok {
    self.handleBlock = handleBlcok;
    [self.hostReachability startNotifier];
}

- (void)setUpViews {
    AdDisconnectView *d = [[AdDisconnectView alloc] init];
    self.d = d;
    UIWindow *w = [[UIApplication sharedApplication].windows lastObject];
    
    [w addSubview:d];
    [w bringSubviewToFront:d];
    
    [d setTranslatesAutoresizingMaskIntoConstraints:NO];
    [w addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[d]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(d)]];
    [w addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(d)]];
    
    d.hidden = YES;
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reachability = [note object];
    self.handleBlock(reachability.currentReachabilityStatus);
    if (reachability == self.hostReachability) {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        if (netStatus == NotReachable) {
            self.d.hidden = NO;
        } else {
            self.d.hidden = YES;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
