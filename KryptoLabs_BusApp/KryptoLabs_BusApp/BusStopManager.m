//
//  BusStopManager.m
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "BusStopManager.h"

@implementation BusStopManager
@synthesize m_BusControllerDelegate;

#pragma mark - Fetch methods
- (void) fetchBusStops :(NSDictionary *)userData
{
    NSURL *url = [NSURL URLWithString:@"http://54.255.135.90/busservice/api/v1/bus-stops/radius?lat=24.44072&lon=54.44392&radius=500"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    fetchBusStopConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (responseData) {
        responseData = nil;
    }
    [fetchBusStopConnection start];
}
- (void) fetchBusList:(NSString *)busStopId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.255.135.90/busservice/api/v1/buses/%@/bus-stops", busStopId]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    fetchBusListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (responseData) {
        responseData = nil;
    }
    [fetchBusListConnection start];
}

- (void) fetchBusRoute:(NSString *)busId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.255.135.90/busservice/api/v1/buses/%@/route", busId]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    fetchBusRouteConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (responseData) {
        responseData = nil;
    }
    [fetchBusRouteConnection start];
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray *stopArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] init];

    if(responseData)
    {
        stopArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", stopArray);
        responseDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:stopArray,@"response",nil];
    }
    else {
    }
    
    if (connection ==  fetchBusStopConnection) {
        if (self.m_BusControllerDelegate && [self.m_BusControllerDelegate respondsToSelector:@selector(busStopRequestCallback:)]){
            [self.m_BusControllerDelegate busStopRequestCallback:responseDictionary];
        }
    }
    else if (connection ==  fetchBusListConnection) {
        if (self.m_BusControllerDelegate && [self.m_BusControllerDelegate respondsToSelector:@selector(busStopRequestCallback:)]){
            [self.m_BusControllerDelegate busStopRequestCallback:responseDictionary];
        }
    }
    else if (connection ==  fetchBusRouteConnection) {
        if (self.m_BusControllerDelegate && [self.m_BusControllerDelegate respondsToSelector:@selector(busStopRequestCallback:)]){
            [self.m_BusControllerDelegate busStopRequestCallback:responseDictionary];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

@end
