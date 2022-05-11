

#import "JQLaunchAdModel.h"

@implementation JQLaunchAdModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.title = dict[@"title"];
        self.version = dict[@"version"];
        self.image = dict[@"image"];
        self.imageDetail = dict[@"imageDetail"];
        self.hideTopImage = [dict[@"hideTopImage"] intValue] != 0;
        self.hideBottomImage = [dict[@"hideBottomImage"]intValue] != 0;
    }
    return self;
}

@end
