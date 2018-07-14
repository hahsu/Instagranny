//
//  YelpManager.m
//  TestYelpAPI
//
//  Created by Hannah Hsu on 7/12/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "YelpManager.h"

/*
 Client ID
 My-u0b-xeFD3zRNnFgrTSA
 
 API Key
 twGNW7wA2e3-suEKeND9MKXRf_kyK0t7xJ5P-9vpNuUizaTTG6KN1WOUIYWeYw0EGDDCpHt4AqI862iz3noXhwC7SJYKyuivB4wAp_zKb_4Od7o2xColAUjYiLVGW3Yx
 
 */

@implementation YelpManager


- (void)getEvent:(NSString *)latitude withLongitude:(NSString *)longitude withCompletion:(void(^)(NSDictionary *categories, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://api.yelp.com/v3/events?limit=1&latitude=%@&longitude=%@", latitude, longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *headerValue=@"Bearer twGNW7wA2e3-suEKeND9MKXRf_kyK0t7xJ5P-9vpNuUizaTTG6KN1WOUIYWeYw0EGDDCpHt4AqI862iz3noXhwC7SJYKyuivB4wAp_zKb_4Od7o2xColAUjYiLVGW3Yx";
    
    
    //[request setValue:@"1531420118" forKey:@"start_date"];
    //[request setValue:@"10" forKey:@"limit"];
    
    //[request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    //[request setValue:headerValue forKey:@"Authorization"];
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary, nil);
            
        }
        
    }];
    [task resume];
    
}

@end
