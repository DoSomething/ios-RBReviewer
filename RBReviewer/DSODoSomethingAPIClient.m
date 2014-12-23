//
//  DSODoSomethingAPIClient.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSODoSomethingAPIClient.h"
#import <AFNetworking.h>

static NSString * const DoSomethingAPIString = @"http://staging.beta.dosomething.org/api/v1/";

@interface DSODoSomethingAPIClient ()

// @property (strong, nonatomic) AFHTTPSessionManager *session;

@end

@implementation DSODoSomethingAPIClient

@synthesize authHeaders;
@synthesize baseUrl;
@synthesize user;


+ (DSODoSomethingAPIClient *)sharedClient
{
    static DSODoSomethingAPIClient *_sharedClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient  = [[self alloc] initWithBaseURL:[NSURL URLWithString:DoSomethingAPIString]];
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
        [self.requestSerializer setValue:key forHTTPHeaderField:value];
        NSLog(@"Adding key=%@ value=%@", key, value);
    }
}

-(void)loginWithCompletionHandler:(void(^)(NSDictionary *))completionHandler andDictionary:(NSDictionary *)authValues
{
    
    [self POST:@"auth/login.json" parameters:authValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.authHeaders = @{
                             @"X-CSRF-Token":responseObject[@"token"],
                             @"Cookie":[NSString stringWithFormat:@"%@=%@", responseObject[@"session_name"], responseObject[@"sessid"]]
                             };
        self.user = responseObject[@"user"];
        [self addAuthHTTPHeaders];
        completionHandler(responseObject);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}



+(NSString *) getEmail
{
    return self.sharedClient.user[@"mail"];
}

        
- (void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler
{
    // Shot in the dark to fix 406 error, per http://stackoverflow.com/questions/21620429/afnetworking-2-0-nslocalizeddescription-request-failed-unacceptable-content-ty

    // self.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self POST:@"auth/logout.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (void)getSingleInboxReportbackCompletionHandler:(void(^)(NSMutableArray *))completionHandler
{
    NSString *filesUrl = @"reportback_files.json?pagesize=1&parameters[status]=pending";
    [self GET:filesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (void)postReportbackReviewWithCompletionHandler:(void(^)(NSArray *))completionHandler :(NSDictionary *)values
{
    ;
    NSString *postUrl = [NSString stringWithFormat:@"reportback_files/%@/review.json", values[@"fid"]];

    [self POST:postUrl parameters:values success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
@end
