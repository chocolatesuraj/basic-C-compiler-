#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "abstract_syntax_tree.h"

expression_node* init_exp_node(char* val, expression_node* left, expression_node* right)
{
    expression_node* node = (expression_node*)malloc(sizeof(expression_node));
    node->val = strdup(val); // Duplicate the string and store it
    node->left = left;
    node->right = right;

    return node;
}
void display_exp_tree(expression_node* exp_node)
{
    if (exp_node == NULL) {
        return;
    }

    printf("%s ", exp_node->val); // Display the current node

    display_exp_tree(exp_node->left); // Traverse the left subtree
    display_exp_tree(exp_node->right); // Traverse the right subtree
}






