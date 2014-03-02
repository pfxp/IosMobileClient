//
//  RequestQueue.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 2/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"
@class IosSessionDataTask;

@interface RequestQueue : NSObject
{
    NSLock *queueLock;
}
@property (readwrite, copy) NSURL *baseUrl;
@property (readwrite) NSURLSession *session;
@property (readwrite) NSMutableArray *queue;

-(id) initWithBaseUrl:(NSURL *)baseUrl
              session:(NSURLSession*)session;
-(void) pushGETRequestToQueue:(IosSessionDataTask *) request;
-(IosSessionDataTask *) popGETRequestFromQueue;
-(void) addRequest:(CamsWsRequest) request;
@end
