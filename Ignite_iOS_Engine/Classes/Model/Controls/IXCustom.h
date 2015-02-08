//
//  IXCustom.h
//  Ignite_iOS_Engine
//
//  Created by Robert Walsh on 2/4/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "IXView.h"

@interface IXCustom : IXView

@property (nonatomic,assign,getter = isFirstLoad) BOOL firstLoad;
@property (nonatomic,strong) NSString* pathToJSON;
@property (nonatomic,strong) NSArray* dataProviders;

@end
