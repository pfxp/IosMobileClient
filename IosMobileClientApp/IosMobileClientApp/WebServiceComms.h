//
//  WebServiceComms.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"
#import "CamsObjectRepository.h"

@interface WebServiceComms : NSObject<NSURLConnectionDelegate>
{
    NSTimeInterval asyncTimeoutInSec;
    NSMutableData *httpResponseData;
    BOOL finishedRequest;
    CamsObjectRepository *repository;
}

@property (readwrite, copy) NSString* helloWorldUrl;
@property (readwrite, atomic) CamsWsRequent currentRequest;


- (id) init;
- (void) asyncTest;

- (NSString *)fetchHelloWorldGreeting;
- (void) callCamsWsMethod:(CamsWsRequent) command;


@end
