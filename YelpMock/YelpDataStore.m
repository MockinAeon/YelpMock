//
//  YelpDataStore.m
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/17/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import "YelpDataStore.h"


@implementation YelpDataStore

+ (YelpDataStore *)sharedInstance {
    static YelpDataStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpDataStore alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]){
        self.selectedCategories = [NSMutableSet new];
    }
    return self;
}

@end
