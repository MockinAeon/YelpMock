//
//  YelpNetworking.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/10/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import CoreLocation;

typedef void (^RestaurantCompletionBlock)(NSArray <YelpDataModel *>* dataModelArray);

@interface YelpNetworking : NSObject

//static --> +
+ (YelpNetworking *)sharedInstance;

- (void) fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term parameters:(NSDictionary *)parameters  completionBlock:(RestaurantCompletionBlock)completionBlock;

@end
