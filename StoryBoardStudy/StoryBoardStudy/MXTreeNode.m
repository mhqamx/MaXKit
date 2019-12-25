//
//  MXTreeNode.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import "MXTreeNode.h"

@implementation MXTreeNode

+ (MXTreeNode *)creatTreeNodesWithValues:(NSArray *)values {
    MXTreeNode *root = nil;
    for (NSInteger i = 0; i < values.count; i++) {
        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
        root = [MXTreeNode addTreeNode:root value:value];
    }
    return root;
}

+ (MXTreeNode *)addTreeNode:(MXTreeNode *)treeNode value:(NSInteger)value {
    //根节点不存在，创建节点
    if (!treeNode) {
        treeNode = [MXTreeNode new];
        treeNode.value = value;
        NSLog(@"node:%@", @(value));
    }
    else if (value <= treeNode.value) {
        NSLog(@"to left");
        //值小于根节点，则插入到左子树
        treeNode.leftNode = [MXTreeNode addTreeNode:treeNode.leftNode value:value];
    }
    else {
        NSLog(@"to right");
        //值大于根节点，则插入到右子树
        treeNode.rightNode = [MXTreeNode addTreeNode:treeNode.rightNode value:value];
    }
    return treeNode;
}

+ (MXTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(MXTreeNode *)rootNode {
    //按层次遍历
    if (!rootNode || index < 0) {
        return nil;
    }
    //数组当成队列
    NSMutableArray *queueArray = [NSMutableArray array];
    //压入根节点
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        MXTreeNode *node = [queueArray firstObject];
        if (index == 0) {
            return node;
        }
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
        //移除节点，index减少
        index--;
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
        
    }
    //层次遍历完，仍然没有找到位置，返回nil

    return nil;
}

+ (void)levelTraverseTree:(MXTreeNode *)rootNode handler:(void(^)(MXTreeNode *treeNode))handler {
    if (!rootNode) {
        return;
    }
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    while (queueArray.count > 0) {
        MXTreeNode *node = [queueArray firstObject];
        if (handler) {
            handler(node);
        }
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先 出原则
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
    }
}

-(void)testSuccess:(void (^)(NSString * _Nonnull))success fail:(void (^)(NSString * _Nonnull))fail {
    success(@"success");
    fail(@"fail");
}

@end




