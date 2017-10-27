//
//  DetailViewHeaderTableViewCell.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/17/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YelpDataModel;

@interface DetailViewHeaderTableViewCell : UITableViewCell

- (void) updateBasedOnDataModel: (YelpDataModel *)dataModel;

@end
