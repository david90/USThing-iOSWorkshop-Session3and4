//
//  SKYSubscription.h
//  SKYKit
//
//  Copyright 2015 Oursky Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

#import "SKYNotificationInfo.h"
#import "SKYQuery.h"

typedef enum : NSInteger {
    SKYSubscriptionTypeQuery = 1,
    SKYSubscriptionTypeRecordZone = 2,
} SKYSubscriptionType;

@interface SKYSubscription : NSObject

- (instancetype)initWithQuery:(SKYQuery *)query;
- (instancetype)initWithQuery:(SKYQuery *)query subscriptionID:(NSString *)subscriptionID;

+ (instancetype)subscriptionWithQuery:(SKYQuery *)query;
+ (instancetype)subscriptionWithQuery:(SKYQuery *)query subscriptionID:(NSString *)subscriptionID;

@property (nonatomic, readonly, assign) SKYSubscriptionType subscriptionType;

@property (nonatomic, readonly) SKYQuery *query;

// probably duplicated with query?
@property (nonatomic, readonly, copy) NSString *recordType;
@property (nonatomic, readonly, copy) NSPredicate *predicate;

@property (nonatomic, copy) SKYNotificationInfo *notificationInfo;

@property (nonatomic, readonly, copy) NSString *subscriptionID;

@end
