//
//  TypeInfo.m
//  appledoc
//
//  Created by Tomaž Kragelj on 4/17/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "Objects.h"
#import "StoreRegistrations.h"
#import "TypeInfo.h"

@implementation TypeInfo

@synthesize typeItems = _typeItems;

#pragma mark - Properties

- (NSMutableArray *)typeItems {
	if (_typeItems) return _typeItems;
	LogStoDebug(@"Initializing type items array due to first access...");
	_typeItems = [[NSMutableArray alloc] init];
	return _typeItems;
}

@end

#pragma mark - 

@implementation TypeInfo (Registrations)

- (void)appendType:(NSString *)type {
	LogStoVerbose(@"Appending type '%@'...", type);
	[self.typeItems addObject:type];
}

@end
