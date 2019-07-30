//
//  MXTreeNode.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2019/5/17.
//  Copyright © 2019 马霄. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXTreeNode : NSObject
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) MXTreeNode *leftNode;
@property (nonatomic, strong) MXTreeNode *rightNode;
// 创建二叉树
+ (MXTreeNode *)creatTreeNodesWithValues:(NSArray *)values;
// 二叉树中某个位置(按层次遍历)
+ (MXTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(MXTreeNode *)rootTree;
// 向二叉树节点添加一个节点
+ (MXTreeNode *)addTreeNode:(MXTreeNode *)treeNode value:(NSInteger)value;
//层次遍历（广度优先)
+ (void)levelTraverseTree:(MXTreeNode *)rootNode handler:(void(^)(MXTreeNode *treeNode))handler;

// 测试block封装内部的执行顺序
- (void)testSuccess:(void(^)(NSString *))success fail:(void(^)(NSString *))fail;

@end

NS_ASSUME_NONNULL_END
