//
//  WebServiceComms.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosMobileClientLib/GlobalSettings.h"
#import "CamsObjectRepository.h"

@interface WebServiceComms : NSObject<NSURLConnectionDelegate>
{
    NSString *helloWorldUrl;
    NSTimeInterval asyncTimeoutInSec;
    NSMutableData *httpResponseData;
    BOOL finishedRequest;
    CamsObjectRepository *repository;
}

@property (readwrite, atomic) NSURL *baseUrl;
@property (readwrite, atomic) CamsWsRequest currentRequest;

- (id) init;
- (NSString *)fetchHelloWorldGreeting;
//- (NSString *)fetchHelloWorldGreetingTwo;
//- (NSString *)helloWorldcompletionHandler:(NSURLResponse *)response  data:(NSData *)data  connError:(NSError *)connectionError;

- (void) callCamsWsMethod:(CamsWsRequest) command;
- (void) setAPNSTokenOnWebService:(NSString *)token;
- (void) setAPNSTokenOnWebServiceAsStream:(NSString *)token;
@end
