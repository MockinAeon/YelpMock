//
//  YelpFilterDataModel.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/24/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpFilterDataModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryCode;

+ (NSArray <YelpFilterDataModel *> *) buildDataModelArrayFromDictionaryArray: (NSArray <NSDictionary *> *) dictArray;

@end
