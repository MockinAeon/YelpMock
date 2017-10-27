//
//  YelpDetailViewController.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/17/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YelpDataModel;
@interface YelpDetailViewController : UIViewController

- (instancetype)initWithDataModel:(YelpDataModel *)dataModel;

@end
