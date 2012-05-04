//
//  CategoryInfoTests.m
//  appledoc
//
//  Created by Tomaž Kragelj on 4/25/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "Store.h"
#import "TestCaseBase.hh"

static void runWithCategoryInfo(void(^handler)(CategoryInfo *info)) {
	CategoryInfo *info = [[CategoryInfo alloc] initWithRegistrar:nil];
	handler(info);
	[info release];
}

#pragma mark - 

SPEC_BEGIN(CategoryInfoTests)

describe(@"category or extension helpers", ^{
	it(@"should work if name of category is nil", ^{
		runWithCategoryInfo(^(CategoryInfo *info) {
			// setup
			info.nameOfCategory = nil;
			// execute & verify
			info.isExtension should equal(YES);
			info.isCategory should equal(NO);
		});
	});
	
	it(@"should work if name of category is empty string", ^{
		runWithCategoryInfo(^(CategoryInfo *info) {
			// setup
			info.nameOfCategory = @"";
			// execute & verify
			info.isExtension should equal(YES);
			info.isCategory should equal(NO);
		});
	});
	
	it(@"should woirk if name of category is not nil and not empty string", ^{
		runWithCategoryInfo(^(CategoryInfo *info) {
			// setup
			info.nameOfCategory = @"a";
			// execute & verify
			info.isExtension should equal(NO);
			info.isCategory should equal(YES);
		});
	});
});

SPEC_END
