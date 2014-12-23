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
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

-(void)loginWithCompletionHandler:(void(^)(NSDictionary *))completionHandler andDictionary:(NSDictionary *)authValues
{
    
    [self POST:@"auth/login.json" parameters:authValues success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.authHeaders = @{
                             @"X-CSRF-Token":responseObject[@"token"],
                             @"Cookie":[NSString stringWithFormat:@"%@=%@", responseObject[@"session_name"], responseObject[@"sessid"]]
                             };
        self.user = responseObject[@"user"];
        completionHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

- (id)init {
    if (self = [super init]) {
        authHeaders = [[NSDictionary alloc] init];

        // Production
        // baseUrl = @"https://www.dosomething.org/api/v1/";

        // Staging
        baseUrl = @"http://staging.beta.dosomething.org/api/v1/";
        
        // Local dev
        // baseUrl = @"http://dev.dosomething.org:8888/api/v1/";

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

+ (void)getSingleInboxReportbackCompletionHandler:(void(^)(NSMutableArray *))completionHandler
{
;
    AFHTTPSessionManager *session = [self getAuthenticatedSession];
    NSString *filesUrl = [self getUrl:@"reportback_files.json?pagesize=1&parameters[status]=pending"];
    [session GET:filesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}

+ (void)postReportbackReviewWithCompletionHandler:(void(^)(NSArray *))completionHandler :(NSDictionary *)values
{
    ;
    AFHTTPSessionManager *session = [self getAuthenticatedSession];
    NSLog(@"%@", values);
    NSString *postUrl = [self getUrl:[NSString stringWithFormat:@"reportback_files/%@/review.json", values[@"fid"]]];

    [session POST:postUrl parameters:values success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@",error.localizedDescription);
    }];
}
@end
