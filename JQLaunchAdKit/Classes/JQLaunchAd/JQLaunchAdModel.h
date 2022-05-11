

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JQLaunchAdModel : NSObject
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *version;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *imageDetail;
@property(nonatomic, assign) BOOL hideTopImage;
@property(nonatomic, assign) BOOL hideBottomImage;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
