//
//  ProtocolInfo.m
//  appledoc
//
//  Created by Tomaž Kragelj on 4/12/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "Objects.h"
#import "ProtocolInfo.h"

@implementation ProtocolInfo

- (NSString *)uniqueObjectID {
	return self.nameOfProtocol;
}

- (NSString *)objectCrossRefPathTemplate {
	return [NSString stringWithFormat:@"$PROTOCOLS/%@.$EXT", self.uniqueObjectID];
}

@end

#pragma mark - 

@implementation ProtocolInfo (Logging)

- (NSString *)description {
	if (!self.nameOfProtocol) return @"protocol";
	return [NSString gb_format:@"@protocol %@ w/ %@", [self uniqueObjectID], [super description]];
}

- (NSString *)debugDescription {
	NSMutableString *result = [self descriptionStringWithComment];
	[result appendFormat:@"@protocol %@", self.nameOfProtocol];
	[result appendString:[super debugDescription]];
	return result;
}

@end
