//
//  Cams.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CamsObjectRepository;
@class IosSessionDataTask;

@interface Cams : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>
{
    NSMutableArray *queue;
}
@property (readwrite, copy) NSURL *baseUrl;
@property (readwrite) CamsObjectRepository *repository;
@property (readwrite) NSURLSession *session;

-(id) initWithBaseUrl:(NSURL*) url;
-(void) createSession;
-(void) addRequests;
-(void) doRequests;

-(void) PushGETRequestToQueue:(IosSessionDataTask *) request;
-(IosSessionDataTask *) PopGETRequestFromQueue;
@end
