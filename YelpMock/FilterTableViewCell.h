//
//  FilterTableViewCell.h
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/24/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YelpFilterDataModel;

@interface FilterTableViewCell : UITableViewCell

- (void) updateDataModel: (YelpFilterDataModel *) dataModel;

@end
