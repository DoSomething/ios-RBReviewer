//
//  DSODoSomethingAPIClient.h
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

// Following http://www.raywenderlich.com/59255/afnetworking-2-0-tutorial for now.
@protocol DSODoSomethingAPIClientDelegate;

@interface DSODoSomethingAPIClient : AFHTTPSessionManager

@property (nonatomic, weak) id<DSODoSomethingAPIClientDelegate>delegate;

@property (strong, nonatomic) NSString *baseUrl;
@property (retain, nonatomic) NSDictionary *authHeaders;
@property (retain, nonatomic) NSDictionary *user;


+ (DSODoSomethingAPIClient *)sharedClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

-(void)loginWithCompletionHandler:(void(^)(NSDictionary *))completionHandler andDictionary:(NSDictionary *)authValues;

+ (NSString *)getEmail;

- (void)getSingleInboxReportbackCompletionHandler:(void(^)(NSMutableArray *))completionHandler;

- (void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler;

- (void)postReportbackReviewWithCompletionHandler:(void(^)(NSArray *))completionHandler :(NSDictionary *)values;

@end
