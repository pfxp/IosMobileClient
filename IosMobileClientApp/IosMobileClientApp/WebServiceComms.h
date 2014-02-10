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

@property (readwrite, atomic) NSString *baseUrl;
@property (readwrite, atomic) CamsWsRequent currentRequest;

- (id) init;
- (NSString *)fetchHelloWorldGreeting;
- (void) callCamsWsMethod:(CamsWsRequent) command;

@end
