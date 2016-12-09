//
//  BusStopManager.m
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "BusStopManager.h"

@implementation BusStopManager
@synthesize m_BusControllerDelegate;

- (void) fetchBusStops :(NSDictionary *)userData
{
    NSURL *url = [NSURL URLWithString:@"http://54.255.135.90/busservice/api/v1/bus-stops/radius?lat=24.44072&lon=54.44392&radius=500"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
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
    NSError* error;
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
    
    if (self.m_BusControllerDelegate && [self.m_BusControllerDelegate respondsToSelector:@selector(busStopRequestCallback:)]){
        [self.m_BusControllerDelegate busStopRequestCallback:responseDictionary];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

@end
