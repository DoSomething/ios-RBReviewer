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

@synthesize authHeaders;
@synthesize baseUrl;
@synthesize user;


+ (DSODoSomethingAPIClient *)sharedClient
{
    static DSODoSomethingAPIClient *sharedClient = nil;
    // Blindly stealing this from http://www.galloway.me.uk/tutorials/singleton-classes/ for now
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (id)init {
    if (self = [super init]) {
        authHeaders = [[NSDictionary alloc] init];
        // baseUrl = @"https://www.dosomething.org/api/v1/";
        baseUrl = @"http://staging.beta.dosomething.org/api/v1/";
        user =[[NSDictionary alloc] init];
    }
    return self;
}


+(NSString *) getEmail
{
    return self.sharedClient.user[@"mail"];
}

+(NSString *)getUrl:(NSString *)endpoint
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.sharedClient.baseUrl, endpoint];
    NSLog(@"%@", urlString);
    return urlString;
    
}

+(void)getActiveCampaignsWithCompletionHandler:(void(^)(NSArray *))completionHandler
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    [session GET:@"https://www.dosomething.org/api/v1/campaigns.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

+(void)loginUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler :(NSDictionary *)authValues
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];

    NSString *loginUrl = [self getUrl:@"auth/login.json"];

    [session POST:loginUrl parameters:authValues success:^(NSURLSessionDataTask *task, id responseObject) {

        self.sharedClient.authHeaders = @{
                        @"X-CSRF-Token":responseObject[@"token"],
                        @"Cookie":[NSString stringWithFormat:@"%@=%@", responseObject[@"session_name"], responseObject[@"sessid"]]
                        };
        self.sharedClient.user = responseObject[@"user"];
        completionHandler(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

+(AFHTTPSessionManager *) getAuthenticatedSession
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];

    for (NSString* key in self.sharedClient.authHeaders) {
        id value = [self.sharedClient.authHeaders objectForKey:key];
        [session.requestSerializer setValue:key forHTTPHeaderField:value];
        NSLog(@"key=%@ value=%@", key, value);
    }
    NSLog(@"%@", session.requestSerializer.description);
    return session;
}
        
+(void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler
{
    AFHTTPSessionManager *session = [self getAuthenticatedSession];
    NSString *logoutUrl = [self getUrl:@"auth/logout.json"];
    [session POST:logoutUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
+(void)getSingleInboxReportbackCompletionHandler:(void(^)(NSArray *))completionHandler
{
;
    AFHTTPSessionManager *session = [self getAuthenticatedSession];
    NSString *filesUrl = [self getUrl:@"reportback_files.json?pagesize=1"];
    [session GET:filesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
@end
