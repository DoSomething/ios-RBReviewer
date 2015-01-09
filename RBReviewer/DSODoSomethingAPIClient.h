//
//  DSODoSomethingAPIClient.h
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface DSODoSomethingAPIClient : AFHTTPSessionManager

@property (strong, nonatomic) NSString *baseUrl;
@property (retain, nonatomic) NSDictionary *authHeaders;
@property (retain, nonatomic) NSDictionary *user;

+ (DSODoSomethingAPIClient *)sharedClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

-(void)loginWithCompletionHandler:(void(^)(NSDictionary *))completionHandler andDictionary:(NSDictionary *)authValues;

-(void)checkStatusWithCompletionHandler:(void(^)(NSDictionary *))completionHandler;

- (void)getSingleInboxReportbackCompletionHandler:(void(^)(NSMutableArray *))completionHandler;

- (void)getTermsWithCompletionHandler:(void(^)(NSMutableArray *))completionHandler;

- (void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler;

- (void)postReportbackReviewWithCompletionHandler:(void(^)(NSArray *))completionHandler :(NSDictionary *)values;

@end
