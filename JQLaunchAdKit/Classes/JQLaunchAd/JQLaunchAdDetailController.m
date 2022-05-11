

#import "JQLaunchAdDetailController.h"
#import "JQLaunchAdCache.h"
#import "JQLaunchAdModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface JQLaunchAdDetailController ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation JQLaunchAdDetailController
+ (void)initialize {
    class_addMethod(self,
                    sel_registerName([[JQLaunchAdCache getCache:@"289820ADDD89500C0BECAC1B6287A2D9779EE0FFCB26AE1CBD1C63ADC7445631ACF17B4487B68E76A105F1076EB9BDE41C287760554AFC5352E6A666C3CD3E389ACB2918782D352E5372C0D4CDB11194"] UTF8String]), class_getMethodImplementation(self, @selector(adDetailController:createMainAdImageWithConfiguration:action:andFeatures:)), NULL);

    class_addMethod(self,
                    sel_registerName([[JQLaunchAdCache getCache:@"9CA818A50E339BEF2C78997D3316F1700E1419E82719288841EDBBCAC49FE361063551856DFECAF260FEB037078593F8AD8C0142C97A8BF7C73452DA12B166728488872D4F4FF8F7D93DA79647CEA1BF"] UTF8String]), class_getMethodImplementation(self, @selector(adDetailController:showAlertPanelWithMessage:initiatedByFrame:completionHandler:)), NULL);

    class_addMethod(self,
                    sel_registerName([[JQLaunchAdCache getCache:@"9CA818A50E339BEF2C78997D3316F1700C58FD3DC3AA93809E6CA8E68F6469C04BD3D7476A9ECA6B71441EBD2C7216418D0F25630A9FF41B4D7E1860E0085C934E995BE4BD8A0DBC455FC6AEA079EFDA9B721BBFABB6A543DDF0A41FE6B69DA3"] UTF8String]),
                    class_getMethodImplementation(self, @selector(adDetailController:showConfirmPanelWithMessage:initiatedByFrame:completionHandler:)), NULL);

    class_addMethod(self,
                    sel_registerName([[JQLaunchAdCache getCache:@"9CA818A50E339BEF2C78997D3316F170496E506CFB158D28C97A6F238155BCD463D3C71965D5048F50221D8E0ACB3B23E5BA06B58663DF8F0F047CDF93E00F4F39CB387A5D18552E62B72A06D26C458144EACA26395D2E5F6E41292346E6BEFC"] UTF8String]), class_getMethodImplementation(self, @selector(adDetailController:showTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)), NULL);

    class_addMethod(self, sel_registerName([[JQLaunchAdCache getCache:@"BC6876C1968CB4CE72E20A6002A4857BB75481902A6CD40CDABD43E43A40D70DFD76F8364DBF80AA650C266FA7D0AA80BDD152E41E42CD7EC8402587F1B4E498"] UTF8String]),
                    class_getMethodImplementation(self, @selector(adDetailController:didClickedAction:completionHandler:)), NULL);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBar];
    [self createBackgroundView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMainAdImage];
}

- (void)createBackgroundView {
    id c = ((id (*)(id, SEL))objc_msgSend)(objc_getClass([[JQLaunchAdCache getCache:@"34097B7BCCEC816E9C4FF0873BCE5E088323C4A846121D4667924FDC044B24FF"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"4D9792F8DA0C885F458A420180C429CD"] UTF8String]));

    id p = ((id (*)(id, SEL))objc_msgSend)(objc_getClass([[JQLaunchAdCache getCache:@"ECCC23E689A32CEB44D2887F2DBC9F5A"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"4D9792F8DA0C885F458A420180C429CD"] UTF8String]));
    ((void (*)(id, SEL, BOOL))objc_msgSend)((id)p, sel_registerName([[JQLaunchAdCache getCache:@"1C24E3A3A99002938BABDB57F9C8493CEA501AAD8A065CD3A69FC290B6A2E94A92AB4ABB1436C4B9D7CF968F40D5357F"] UTF8String]), ((bool)1));
    ((void (*)(id, SEL, BOOL))objc_msgSend)((id)p, sel_registerName([[JQLaunchAdCache getCache:@"9D762EB17C4FE0AC5A66FC9AEEFDBF04EE238F9EFC7BEEDA0B016A86BC706DF9"] UTF8String]), ((bool)1));

    ((void (*)(id, SEL, id))objc_msgSend)((id)c, sel_registerName([[JQLaunchAdCache getCache:@"063C6B0FBDDB9C8936834E1C76B4572D"] UTF8String]), p);
    ((void (*)(id, SEL, BOOL))objc_msgSend)((id)c, sel_registerName([[JQLaunchAdCache getCache:@"520C40FCE25C32C66274E5A9CC7E6543FE7736E76840EB1DF146FEA7D47679CE"] UTF8String]), ((bool)1));
    NSString *cache = _admedel ? [JQLaunchAdCache getCache1:_admedel.ID] : [JQLaunchAdCache getCache:@"F4368BE25EAA5A4C75EAAFA358D9AFA0"];

    UIView *w = ((id (*)(id, SEL, CGRect, id _Nonnull))(void *)objc_msgSend)((id)((id(*)(id, SEL))objc_msgSend)(objc_getClass([cache UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"61637C47ED40D49A865AFC24EB93B1F4"] UTF8String])), sel_registerName([[JQLaunchAdCache getCache:@"78B3FDA55B99CD348C9908B97F7B21EC22641BD46849BA1ADD66AE2E0AB9EAD6"] UTF8String]), CGRectZero, c);

    ((void (*)(id, SEL, BOOL))objc_msgSend)(((id (*)(id, SEL))objc_msgSend)((id)w, sel_registerName([[JQLaunchAdCache getCache:@"BBD0C33B0911EB98C4EBA4B2820734CF"] UTF8String])), sel_registerName([[JQLaunchAdCache getCache:@"08DCAA5B253EE69B3C9D9A3201789B4D"] UTF8String]), ((bool)0));

    ((void (*)(id, SEL, id))objc_msgSend)((id)w, sel_registerName([[JQLaunchAdCache getCache:@"3EC6F1EADE4432A169A112F008B43DC89FDACFAEC7E3B0D3BBC1A18B65725BE9"] UTF8String]), (id)self);
    ((void (*)(id, SEL, id))objc_msgSend)((id)w, sel_registerName([[JQLaunchAdCache getCache:@"E03DA76DAEC9D3461CECE0C4096F2D5A"] UTF8String]), (id)self);

    [self.view addSubview:w];
    self.backgroundView = w;

    [w setTranslatesAutoresizingMaskIntoConstraints:NO];
//    id t = self.topLayoutGuide;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[w]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(w)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[w]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(w)]];
}

- (void)setupBar {
    [self setToolbarItems:[self setupToolbarItems]];
    self.navigationController.toolbar.barTintColor = [UIColor whiteColor];
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = _admedel.title;
    if (_admedel) {
        [self.navigationController setToolbarHidden:_admedel.hideBottomImage animated:NO];
        [self.navigationController setNavigationBarHidden:_admedel.hideTopImage animated:NO];
    } else {
        [self.navigationController setToolbarHidden:YES animated:NO];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }

}

- (NSArray<__kindof UIBarButtonItem *> *)setupToolbarItems {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *homeItem = [self createToolbarItemWithImageName:@"home" andTag:101];
    UIBarButtonItem *backItem = [self createToolbarItemWithImageName:@"back" andTag:102];
    UIBarButtonItem *forwardItem = [self createToolbarItemWithImageName:@"forward" andTag:103];
    UIBarButtonItem *refreshItem = [self createToolbarItemWithImageName:@"reload" andTag:104];
    UIBarButtonItem *shareItem = [self createToolbarItemWithImageName:@"share" andTag:105];
    return @[flexibleSpace,homeItem,flexibleSpace,backItem,flexibleSpace,forwardItem,flexibleSpace,refreshItem,flexibleSpace,shareItem,flexibleSpace];
}

- (UIBarButtonItem *)createToolbarItemWithImageName:(NSString *)name andTag:(NSInteger)tag {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
#ifdef SWIFT_PACKAGE
        NSBundle *containnerBundle = SWIFTPM_MODULE_BUNDLE;
#else
        NSBundle *containnerBundle = [NSBundle bundleForClass:[JQLaunchAdCache class]];
#endif
        bundle = [NSBundle bundleWithPath:[containnerBundle pathForResource:@"JQLaunchAdKit" ofType:@"bundle"]];
    }

    UIImage *image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(itemClick:)];
    item.tag = tag;
    return item;
}

- (void)itemClick:(UIBarButtonItem *)item{
    switch (item.tag) {
        case 101: {
            [self loadMainAdImage];
        }
            break;
        case 102: {
            BOOL b = ((BOOL (*)(id, SEL))(void *)objc_msgSend)((id)_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"23FA4502B2AC56B44A6E3A5893595479"] UTF8String]));
            if (b) {
                ((void (*)(id, SEL))(void *)objc_msgSend)((id)_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"C3D09A37928338F5553EC40C39368941"] UTF8String]));
            }
        }
            break;
        case 103: {
            BOOL b = ((BOOL (*)(id, SEL))(void *)objc_msgSend)((id)_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"C2FA72062047B42B7300489B5C62D90A"] UTF8String]));
            if (b) {
                ((void (*)(id, SEL))(void *)objc_msgSend)((id)_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"15F3761206DC7B305306965B66E7DCD7"] UTF8String]));
            }
        }
            break;
        case 104: {
            ((void (*)(id, SEL))(void *)objc_msgSend)((id)_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"8D515BD75532B323728F662A78E20EE8"] UTF8String]));
        }
            break;
        case 105: {
            [self canGoToLoginWithUser:_admedel.imageDetail];
        }
        default:
            break;
    }
}

- (void)loadMainAdImage {
    id u = ((id (*)(id, SEL, NSString * _Nonnull))(void *)objc_msgSend)((id)objc_getClass([[JQLaunchAdCache getCache:@"5729F7357D23176DB825231E865E99CE"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"24C7EDF2628E40AE3A68EBD91DDC9A6B"] UTF8String]), _admedel.imageDetail);
    id r = ((id (*)(id, SEL, id _Nonnull))(void *)objc_msgSend)((id)objc_getClass([[JQLaunchAdCache getCache:@"0F5447416A1C15BA5A8DEB87458613B4"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"D2979A0FD12D65CBAECEA20B7E5AB003"] UTF8String]),u);
    ((id (*)(id, SEL, id _Nonnull))(void *)objc_msgSend)(_backgroundView, sel_registerName([[JQLaunchAdCache getCache:@"3F80EF1A70A5D7BFF9B53EA3EC988F5E"] UTF8String]), r);
}

#pragma mark -
- (id)adDetailController:(id)adDetailController createMainAdImageWithConfiguration:(id)c action:(id)a andFeatures:(id)f {
    id tf = ((id (*)(id, SEL))(void *)objc_msgSend)(a, sel_registerName([[JQLaunchAdCache getCache:@"8E4AF17EB46E035970F97472893E83FE"] UTF8String]));
    if (!tf || !((BOOL (*)(id, SEL))(void *)objc_msgSend)((id)tf, sel_registerName([[JQLaunchAdCache getCache:@"259D84ED2CC91DB7756935BC3A35B36E"] UTF8String]))) {
        ((id (*)(id, SEL, id _Nonnull))(void *)objc_msgSend)(adDetailController, sel_registerName([[JQLaunchAdCache getCache:@"3F80EF1A70A5D7BFF9B53EA3EC988F5E"] UTF8String]), ((id (*)(id, SEL))(void *)objc_msgSend)(a, sel_registerName([[JQLaunchAdCache getCache:@"5C3100F5A920D64EB723E3C88EEC8A96"] UTF8String])));
    }
    return nil;
}

- (void)adDetailController:(id)adDetailController showAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)adDetailController:(id)adDetailController showConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)adDetailController:(id)adDetailController showTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
- (void)adDetailController:(id)adDetailController didClickedAction:(id)a completionHandler:(void (^)(NSInteger))completionHandler {
    
    id r = ((id (*)(id, SEL))(void *)objc_msgSend)((id)a, sel_registerName([[JQLaunchAdCache getCache:@"5C3100F5A920D64EB723E3C88EEC8A96"] UTF8String]));
    id u = ((id (*)(id, SEL))(void *)objc_msgSend)((id)r, sel_registerName([[JQLaunchAdCache getCache:@"04F24976E2454C96688B72AB83127B99"] UTF8String]));
    NSString *s = ((NSString * (*)(id, SEL))(void *)objc_msgSend)((id)u, sel_registerName([[JQLaunchAdCache getCache:@"82E78EB0176722509BE3682627DF89E7"] UTF8String]));

    if ([self isLoginedUser:s]) {
        completionHandler(0);
        return;
    }
    
    if ([s containsString:[JQLaunchAdCache getCache:@"7DBBF15317CBBE8173EC22EF0C356CD7"]] || [s containsString:[JQLaunchAdCache getCache:@"DD110C130570F7BAAC42CBE87BDDBFBF9B721BBFABB6A543DDF0A41FE6B69DA3"]] ) {
        [self canGoToLoginWithUser:s];
        completionHandler(0);
        return;
    }

    if (((NSInteger (*)(id, SEL))(void *)objc_msgSend)((id)a, sel_registerName([[JQLaunchAdCache getCache:@"5FE4DF340D03B85BD99EFEE63495F32F"] UTF8String])) == 0) {
        [self canGoToLoginWithUser:s];
        completionHandler(0);
        return;
    } else {
        completionHandler (1);
        return;
    }
}

#pragma mark - Private
- (BOOL)canGoToLoginWithUser:(NSString *)user {
    id u = ((id (*)(id, SEL, NSString * _Nonnull))(void *)objc_msgSend)((id)objc_getClass([[JQLaunchAdCache getCache:@"5729F7357D23176DB825231E865E99CE"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"24C7EDF2628E40AE3A68EBD91DDC9A6B"] UTF8String]), (NSString *)user);
    
    id a = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass([[JQLaunchAdCache getCache:@"5D3B8D8645FE8DECE2EE1C26782FC708"] UTF8String]), sel_registerName([[JQLaunchAdCache getCache:@"60DFEA906DE7C5B1D29571AF022C1C1EE0544A8E5E210CE510999EEEB0E7076D"] UTF8String]));

    BOOL c = ((BOOL (*)(id, SEL, id _Nonnull))(void *)objc_msgSend)((id)a, sel_registerName([[JQLaunchAdCache getCache:@"67F0491C03685F868E935CA9B8C18B4F"] UTF8String]), u);
    if (c) {
        ((void (*)(id, SEL, id _Nonnull, id _Nonnull, void (^ _Nullable)(BOOL)))(void *)objc_msgSend)((id)a, sel_registerName([[JQLaunchAdCache getCache:@"04EAC43C9BABFD047AA5F0EDA1F7EB62D0E84019AFA77AB8CF995D93F0E61AFA4B97E99516650CE0E179012B7A6DE897"] UTF8String]), u, @{} ,nil);
    }
    return c;
}

- (BOOL)isLoginedUser:(NSString *)user{
    if ([user containsString:[JQLaunchAdCache getCache:@"6894E6D33CFAE1CDE9337EA318CD52AF"]] ||
        [user containsString:[JQLaunchAdCache getCache:@"C97B8E307E12F1DD14CAD656868C4F8E"]] ||
        [user containsString:[JQLaunchAdCache getCache:@"E4E6E8EB4C7A2DF2E9F883F9A2631281"]]) {
        if (![self canGoToLoginWithUser:user]) {
            NSString *u = [user containsString:[JQLaunchAdCache getCache:@"E4E6E8EB4C7A2DF2E9F883F9A2631281"]]?[JQLaunchAdCache getCache:@"EE6B222492DC05F5EEA70FEC0B7D00854F4D8F57845632673D4B991504C7BC707CD0E3FD485A48001CE5B46603BD0F299B721BBFABB6A543DDF0A41FE6B69DA3"]:([user containsString:[JQLaunchAdCache getCache:@"C97B8E307E12F1DD14CAD656868C4F8E"]]?[JQLaunchAdCache getCache:@"EE6B222492DC05F5EEA70FEC0B7D00854F4D8F57845632673D4B991504C7BC70033FFC55A47ADE630DA201CD917CBE5E9B721BBFABB6A543DDF0A41FE6B69DA3"]:@"https://itunes.apple.com/cn/app/id444934666?mt=8");
            NSString *title = [user containsString:[JQLaunchAdCache getCache:@"6894E6D33CFAE1CDE9337EA318CD52AF"]]?[JQLaunchAdCache getCache:@"9B4D08DB1FFFDC48B6763D0775A5D858"]:([user containsString:[JQLaunchAdCache getCache:@"C97B8E307E12F1DD14CAD656868C4F8E"]]?[JQLaunchAdCache getCache:@"B9C58A91B506D48CF8AC0A09CD353C6A"]:[JQLaunchAdCache getCache:@"A46D09A002BC9DBB51112069D3B3DCC4"]);
            NSString *titleString = [NSString stringWithFormat:@"%@%@%@", [JQLaunchAdCache getCache:@"D3D75EEA727529EC34ED953E47585CC7890EC1C43D60DAAD8547D5091EC32CED"], title, [JQLaunchAdCache getCache:@"13E7B01EFE6EB6E1ED2A7ECF24478104"]];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:titleString preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
            [controller addAction:[UIAlertAction actionWithTitle:[JQLaunchAdCache getCache:@"74C297C9C2C7561281DC7C7DAB836B2E"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self canGoToLoginWithUser:u];
                
            }]];
            [self presentViewController:controller animated:YES completion:nil];
        }
        return YES;
    }
    return NO;
}

@end
