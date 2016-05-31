//
//  ZLXMLParsers.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.28..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISNODENAME                              isEqualToString:[node name]
#define IS_NAMED_NODE(node)                     isEqualToString:[node name]
#define SETSTRNODEVALUE(strname,setter)         if ([strname ISNODENAME]) [setter:[node value]]; else
#define SETINTNODEVALUE(strname,setter)         if ([strname ISNODENAME]) [setter:[[node value] integerValue]]; else
#define SETBOOLNODEVALUE(strname,setter)        if ([strname ISNODENAME]) [setter:[[node value] boolValue]]; else
#define NODENOTPROCESSED                        NSLog(NODE_NOT_PROCESSED,[node name]);
#define GET_NAMED_INTEGER_ATTRIBUTE(Attribute)  [[node attributeNamed:Attribute] intValue]

@interface MXMLParsers : NSObject
+ (id) LoginResponse:(NSArray *)nodes;
@end
