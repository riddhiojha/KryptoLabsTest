//
//  BusListController.m
//  KryptoLabs_BusApp
//
//  Created by Riddhi Ojha on 12/10/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "BusListController.h"
#import "BusListTVC.h"

@interface BusListController ()

@end

@implementation BusListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Managing the bus list

- (void)setBusStopId:(NSString *)busStopId {
    busStopManager = [[BusStopManager alloc] init];
    busStopManager.m_BusControllerDelegate = self;
    [busStopManager fetchBusList:busStopId];
}
#pragma mark - Busstopmanager delegate
- (void) busStopRequestCallback : (NSDictionary *)responseDictionary
{
    busListArray = responseDictionary[@"response"];
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return busListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"busListCellIdentifier" forIndexPath:indexPath];
    cell.busName.text = busListArray[indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPathSelected = indexPath;
    [self performSegueWithIdentifier:@"openBusDetail" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"openBusDetail"]) {
        BusDetailController *controller = (BusDetailController *)[segue destinationViewController];
        NSString *busId = busListArray[indexPathSelected.row][@"id"];
        [controller setBusId:busId];
    }
}


@end
