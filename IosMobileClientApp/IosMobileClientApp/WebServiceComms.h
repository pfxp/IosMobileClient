//
//  WebServiceComms.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceComms : NSObject<NSURLConnectionDelegate>
{
    NSTimeInterval asyncTimeoutInSec;
    NSMutableData *httpResponseData;
}

@property (readwrite, copy) NSString* helloWorldUrl;

- (id) init;
- (void) asyncTest;

- (NSString *)fetchHelloWorldGreeting;
@end
