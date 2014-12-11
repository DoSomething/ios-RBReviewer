//
//  DSODoSomethingAPIClient.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSODoSomethingAPIClient.h"
#import <AFNetworking.h>


@implementation DSODoSomethingAPIClient

+(void)getActiveCampaignsWithCompletionHandler:(void(^)(NSArray *))completionHandler
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    [session GET:@"https://www.dosomething.org/api/v1/campaigns.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

+(void)loginUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler :(NSDictionary *)auth
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];

    NSString *baseUrl = @"https://www.dosomething.org/api/v1/";
    NSString *authUrl = [NSString stringWithFormat:@"%@auth/login.json", baseUrl];

    [session POST:authUrl parameters:auth success:^(NSURLSessionDataTask *task, id responseObject) {
   
        completionHandler(responseObject);


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
@end
