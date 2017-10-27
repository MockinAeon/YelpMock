//
//  YelpTableViewCell.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/12/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"
@interface YelpTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
