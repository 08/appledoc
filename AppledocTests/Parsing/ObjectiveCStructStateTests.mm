//
//  ObjectiveCStructStateTests.m
//  appledoc
//
//  Created by Tomaž Kragelj on 3/30/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "ObjectiveCStructState.h"
#import "ObjectiveCStateTestsHelpers.h"
#import "TestCaseBase.hh"

static void runWithState(void(^handler)(ObjectiveCStructState *state)) {
	ObjectiveCStructState* state = [[ObjectiveCStructState alloc] init];
	handler(state);
	[state release];
}

#pragma mark - 

SPEC_BEGIN(ObjectiveCStructStateTests)

describe(@"empty struct", ^{
	it(@"should detect", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct {};", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] endCurrentObject];
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});
});

describe(@"single item and value", ^{
	it(@"should detect single type and no value", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct { type item; };", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"type"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"item"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] endCurrentObject]; // struct
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});

	it(@"should detect multiple types and no value", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct { type1 type2 type3 item; };", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"type1"];
				[[store expect] appendType:@"type2"];
				[[store expect] appendType:@"type3"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"item"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] endCurrentObject]; // struct
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});
});

describe(@"multiple items", ^{
	it(@"should detect single type and no value", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct { type1 item1; type2 item2; };", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"type1"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"item1"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"type2"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"item2"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] endCurrentObject]; // struct
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});

	it(@"should detect multiple types and no values", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct { typeA1 typeA2 typeA3 itemA; typeB1 typeB2 typeB3 itemB; };", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"typeA1"];
				[[store expect] appendType:@"typeA2"];
				[[store expect] appendType:@"typeA3"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"itemA"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] beginConstant];
				[[store expect] beginConstantTypes];
				[[store expect] appendType:@"typeB1"];
				[[store expect] appendType:@"typeB2"];
				[[store expect] appendType:@"typeB3"];
				[[store expect] endCurrentObject]; // types
				[[store expect] appendConstantName:@"itemB"];
				[[store expect] endCurrentObject]; // constant
				[[store expect] endCurrentObject]; // struct
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});
});

describe(@"fail cases", ^{
	it(@"should cancel if start of struct body is missing", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct word1 word2 word3 };", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] cancelCurrentObject];
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});

	it(@"should cancel if end of struct body is missing", ^{
		runWithState(^(ObjectiveCStructState *state) {
			runWithString(@"struct { item ;", ^(id parser, id tokens) {
				// setup
				id store = [OCMockObject mockForClass:[Store class]];
				[[store expect] setCurrentSourceInfo:OCMOCK_ANY];
				[[store expect] beginStruct];
				[[store expect] beginConstant];
				[[store expect] appendConstantName:@"item"];
				[[store expect] endCurrentObject]; // succesfull constant "item" parsed!
				[[store expect] cancelCurrentObject];
				[[parser expect] popState];
				// execute
				[state parseStream:tokens forParser:parser store:store];
				// verify
				^{ [store verify]; } should_not raise_exception();
				^{ [parser verify]; } should_not raise_exception();
			});
		});
	});
});

SPEC_END
