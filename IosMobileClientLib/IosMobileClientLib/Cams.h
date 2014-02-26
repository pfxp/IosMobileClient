//
//  Cams.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//
// Handles all Web Service communications with the CAMS Server.
// Contains the CAMS Object Repository which contains lists of Zones,
#import <Foundation/Foundation.h>
#import "CamsObjectRepository.h"

@class IosSessionDataTask;

@interface Cams : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (readwrite) NSMutableArray *queue;
@property (readwrite, copy) NSURL *baseUrl;
@property (readwrite) NSURLSession *session;
@property (readwrite) CamsObjectRepository *repository;
@property (readwrite) NSMutableDictionary *dataFromWebService;

-(id) initWithBaseUrl:(NSURL*) url;
-(void) createSession;
-(void) addRequests;
-(void) doRequests;
-(void) pushGETRequestToQueue:(IosSessionDataTask *) request;
-(IosSessionDataTask *) popGETRequestFromQueue;
-(void) registerApnsToken:(NSString *) token;
-(void) addData:(NSUInteger)taskId  data:(NSData*)data;
@end
