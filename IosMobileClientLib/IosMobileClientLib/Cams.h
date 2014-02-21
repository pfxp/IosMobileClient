//
//  Cams.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"
//#import "CamsObjectRepository.h"

@interface Cams : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>
{
  //  CamsObjectRepository *repository;
}

@property (readonly, copy) NSString *controllersUrl;
@property (readwrite) NSURLSession *session;
-(id) init;
-(void) start;
-(void) GetControllers;
-(void) GetControllers2;

@end
