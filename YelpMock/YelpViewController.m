//
//  ViewController.m
//  YelpMock
//
//  Created by Mockin_Aeon. on 10/10/17.
//  Copyright © 2017 Mockin_Aeon. All rights reserved.
//

#import "YelpViewController.h"
#import "YelpNetworking.h"
#import "YelpTableViewCell.h"
#import "YelpDataStore.h"
#import "YelpDetailViewController.h"
#import "FilterViewController.h"
@interface YelpViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *infiniteLoadingIndicator;

@end

@implementation YelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame: self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    CLLocation *loc = [[YelpDataStore sharedInstance] userLocation];
    
    if (!loc) {
        //mock loc
        loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    }

    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:self.searchBar.text ? :@"restaurant" parameters: [self _generateNetworkRelatedParameters] completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"YelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"YelpTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettings)];
    
    //setup search bar
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor lightGrayColor];
    self.navigationItem.titleView = self.searchBar;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(didPullToRefresh) forControlEvents:UIControlEventValueChanged];
    
    self.infiniteLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    self.tableView.tableFooterView = self.infiniteLoadingIndicator;
}

- (void) didTapSettings
{
    FilterViewController *filterVC = [[FilterViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)didPullToRefresh
{
    CLLocation *loc = [[YelpDataStore sharedInstance] userLocation];
    
    if (!loc) {
        //mock loc
        loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    }
    [self.refreshControl beginRefreshing];
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:self.searchBar.text ? :@"restaurant" parameters: [self _generateNetworkRelatedParameters] completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        [self.refreshControl endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];
    
    [cell updateBasedOnDataModel:self.dataModels[indexPath.row]];
    
    if (indexPath.row ==  [self.dataModels count] - 4) {
        [self loadMoreData];
    }
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModels count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    
    // the following code the key that we can finally make our table be able to search based on user’s input
    
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:searchBar.text parameters: [self _generateNetworkRelatedParameters] completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - Location manager methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations firstObject];
    
    [[YelpDataStore sharedInstance] setUserLocation:currentLocation];
    [manager stopUpdatingLocation];
    
    NSLog(@"current location %lf %lf", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:currentLocation  term:self.searchBar.text ? :@"restaurant" parameters: [self _generateNetworkRelatedParameters] completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpDetailViewController *detailVC = [[YelpDetailViewController alloc] initWithDataModel: self.dataModels[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - internal
- (void) loadMoreData
{
    CLLocation *loc = [[YelpDataStore sharedInstance] userLocation];
    
    if (!loc) {
        //mock loc
        loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    }
    NSMutableDictionary *parameter = [[self _generateNetworkRelatedParameters] mutableCopy];
    [parameter setObject:[@([self.dataModels count]) stringValue] forKey:@"offset"];
    [self.infiniteLoadingIndicator startAnimating];
    
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:self.searchBar.text ? :@"restaurant" parameters: parameter completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        [self.infiniteLoadingIndicator stopAnimating];
        if ([dataModelArray count]) {
            NSMutableArray *mutableArray = [self.dataModels mutableCopy];
            [mutableArray addObjectsFromArray:dataModelArray];
            self.dataModels = [mutableArray copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSDictionary *) _generateNetworkRelatedParameters
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *categories = @"";
    for (NSString *string in [YelpDataStore sharedInstance].selectedCategories) {
        if (categories.length) {
            categories = [categories stringByAppendingString:@","];
            categories = [categories stringByAppendingString:string];
        } else {
            categories = string;
        }
    }
    
    if (categories.length) {
        [dict setObject:categories forKey:@"categories"];
    }
    
    if ([[YelpDataStore sharedInstance] priceParameter]) {
        [dict setObject:[[YelpDataStore sharedInstance] priceParameter] forKey:@"price"];
    }
    [dict setObject:[@(0) stringValue] forKey:@"offset"];
    return [dict copy];
}

@end
