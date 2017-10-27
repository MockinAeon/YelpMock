//
//  PriceTableViewCell.m
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/24/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import "PriceTableViewCell.h"
#import "YelpDataStore.h"
@interface PriceTableViewCell()
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceSegment;

@end

@implementation PriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.priceSegment setTitle:@"$" forSegmentAtIndex:0];
    [self.priceSegment setTitle:@"$$" forSegmentAtIndex:1];
    [self.priceSegment setTitle:@"$$$" forSegmentAtIndex:2];
    [self.priceSegment setTitle:@"$$$$" forSegmentAtIndex:3];
    if ([YelpDataStore sharedInstance].priceParameter) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[YelpDataStore sharedInstance].priceParameter];
        [self.priceSegment setSelectedSegmentIndex:[myNumber integerValue] - 1];
    }
}

- (IBAction)didSelectSegment:(id)sender {
    // 1 = $, 2 = $$, 3 = $$$, 4 = $$$$
    [YelpDataStore sharedInstance].priceParameter = [NSString stringWithFormat:@"%li", self.priceSegment.selectedSegmentIndex + 1];
}


@end
