//
//  DSODoSomethingAPIClient.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSODoSomethingAPIClient.h"
#import <AFNetworking.h>
#import <TSMessage.h>
#import <SSKeychain/SSKeychain.h>

@interface DSODoSomethingAPIClient ()

@end

@implementation DSODoSomethingAPIClient

@synthesize authHeaders;
@synthesize serviceName;
@synthesize user;


+ (DSODoSomethingAPIClient *)sharedClient
{
    NSString *server = @"www.dosomething.org";
    NSString *protocol = @"https";
    #ifdef DEBUG
        server = @"staging.beta.dosomething.org";
        protocol =@"http";
    #endif
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@://%@/api/v1/", protocol, server];
    static DSODoSomethingAPIClient *_sharedClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient  = [[self alloc] initWithBaseURL:[NSURL URLWithString:apiEndpoint]];
        _sharedClient.serviceName = server;
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.authHeaders = [[NSDictionary alloc] init];
        self.user = [[NSDictionary alloc] init];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

-(void) addAuthHTTPHeaders
{
    for (NSString* key in self.authHeaders) {
        id value = [self.authHeaders objectForKey:key];
        [self.requestSerializer setValue:value forHTTPHeaderField:key];
        NSLog(@"Adding key=%@ value=%@", key, value);
    }
}

-(void)loginWithCompletionHandler:(void(^)(NSDictionary *))completionHandler andDictionary:(NSDictionary *)authValues andViewController:(UIViewController *)vc
{
    
    [self POST:@"auth/login.json" parameters:authValues success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"authValues:%@", authValues);
        self.authHeaders = @{
                             @"X-CSRF-Token":responseObject[@"token"],
                             @"Cookie":[NSString stringWithFormat:@"%@=%@", responseObject[@"session_name"], responseObject[@"sessid"]]
                             };
        self.user = responseObject[@"user"];
        [self addAuthHTTPHeaders];
        completionHandler(responseObject);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
        [TSMessage showNotificationInViewController:vc
                                              title:@"Aw, shit"
                                           subtitle:error.localizedDescription
                                               type:TSMessageNotificationTypeError];
    }];
}

-(void)checkStatusWithCompletionHandler:(void(^)(NSDictionary *))completionHandler
{
    
    [self POST:@"system/connect.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

        
- (void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler
{
    
    [self POST:@"auth/logout.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (void)getSingleInboxReportbackWithCompletionHandler:(void(^)(NSMutableArray *))completionHandler andTid:(NSInteger)tid
{
    
    NSString *url = [NSString stringWithFormat:@"terms/%li/inbox.json?count=1", tid];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (void)getTermsWithCompletionHandler:(void(^)(NSMutableArray *))completionHandler
{

    NSString *url = @"terms.json";
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (void)postReportbackReviewWithCompletionHandler:(void(^)(NSArray *))completionHandler :(NSDictionary *)values
{

    NSString *postUrl = [NSString stringWithFormat:@"reportback_files/%@/review.json", values[@"fid"]];

    [self POST:postUrl parameters:values success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
@end
