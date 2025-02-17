#include <Windows.h>
#include <stdio.h>

typedef struct                          BinarySearchTree
{
    size_t                  key;
    struct BinarySearchTree *left, *right;
}                                       BinarySearchTree;
static BinarySearchTree                 *insertBST(BinarySearchTree *root, size_t key)
{
    if      (!root)
    {
        root        = (BinarySearchTree*)malloc(sizeof(BinarySearchTree));

        if          (!root) ExitProcess(1);

        root->key   = key;
        root->left  = root->right = NULL;

        return      root;
    }
    else if (key < root->key) root->left = insertBST(root->left, key);
    else if (key > root->key) root->right = insertBST(root->right, key);

    return  root;
}
static unsigned int                     countBST(BinarySearchTree *root)
{
    if      (!root) return 0;

    return  1 + countBST(root->left) + countBST(root->right);
}
static void                             inorderBST(BinarySearchTree *root, size_t arr[], size_t *index)
{
    if              (!root) return;

    inorderBST(root->left, arr, index);

    arr[(*index)++] = root->key;

    inorderBST(root->right, arr, index);
}
static BinarySearchTree                 *findMinBST(BinarySearchTree *root)
{
    while   (root && root->left) root = root->left;

    return  root;
}
static BinarySearchTree                 *eraseBST(BinarySearchTree *root, size_t key)
{
    if      (!root) return NULL;
    else if (key < root->key) root->left = eraseBST(root->left, key);
    else if (key > root->key) root->right = eraseBST(root->right, key);  
    else if (!root->left)
    {
        BinarySearchTree    *temp = root->right;

        free(root);

        return              temp;
    }
    else if             (!root->right)
    {
        BinarySearchTree    *temp = root->left;

        free(root);

        return              temp;
    }
    else
    {
        BinarySearchTree    *temp = findMinBST(root->right);
        root->key           = temp->key;
        root->right         = eraseBST(root->right, temp->key);
    }

    return  root;
}
static void                             freeBST(BinarySearchTree *root)
{
    if (!root) return;

    freeBST(root->left);
    freeBST(root->right);

    free(root);
}
typedef struct                          BinarySearchTreeString
{
    char                            *key;
    struct BinarySearchTreeString   *left, *right;
}                                       BinarySearchTreeString;
static BinarySearchTreeString           *insertBSTString(BinarySearchTreeString *root, const char *key)
{
    if              (!root)
    {
        root        = (BinarySearchTreeString*)malloc(sizeof(BinarySearchTreeString));

        if          (!root) ExitProcess(1);

        root->key   = _strdup(key);

        if          (!root->key) ExitProcess(1);

        root->left  = root->right = NULL;

        return      root;
    }
    else if (strcmp(key, root->key) < 0) root->left = insertBSTString(root->left, key);
    else if (strcmp(key, root->key) > 0) root->right = insertBSTString(root->right, key);

    return root;
}
static unsigned int                     countBSTString(BinarySearchTreeString *root)
{
    if      (!root) return 0;

    return  1 + countBSTString(root->left) + countBSTString(root->right);
}
static void                             inorderBSTString(BinarySearchTreeString *root, char *arr[], size_t *index)
{
    if              (!root) return;

    inorderBSTString(root->left, arr, index);

    arr[(*index)++] = root->key;

    inorderBSTString(root->right, arr, index);
}
static BinarySearchTreeString           *findMinBSTString(BinarySearchTreeString *root)
{
    while   (root && root->left) root = root->left;

    return  root;
}
static BinarySearchTreeString           *eraseBSTString(BinarySearchTreeString *root, const char *key)
{
    if                          (!root) return NULL;
    else if                     (strcmp(key, root->key) < 0) root->left = eraseBSTString(root->left, key);
    else if                     (strcmp(key, root->key) > 0) root->right = eraseBSTString(root->right, key);
    else if                     (!root->left)
    {
        BinarySearchTreeString  *temp = root->right;

        free(root->key);
        free(root);

        return                  temp;
    }
    else if                     (!root->right)
    {
        BinarySearchTreeString  *temp = root->left;

        free(root->key);
        free(root);

        return                  temp;
    }
    else
    {
        BinarySearchTreeString  *temp = findMinBSTString(root->right);

        free(root->key);

        root->key               = _strdup(temp->key);

        root->right             = eraseBSTString(root->right, temp->key);
    }

    return                      root;
}
static void                             freeBSTString(BinarySearchTreeString *root)
{
    if (!root) return;

    freeBSTString(root->left);
    freeBSTString(root->right);

    free(root->key);
    free(root);
}
int                                     main()
{
    // Insert integers into the BST
    BinarySearchTree    *root = insertBST(NULL, 50);
    root                = insertBST(root, 50);
    root                = insertBST(root, 30);
    root                = insertBST(root, 70);
    root                = insertBST(root, 20);
    root                = insertBST(root, 40);
    root                = insertBST(root, 60);
    root                = insertBST(root, 80);

    // Count the number of nodes
    printf_s("Count of BST nodes: %u\n", countBST(root));

    // In-order traversal
    size_t                  arr[10], index = 0;

    inorderBST(root, arr, &index);

    printf_s("In-order traversal: ");

    for                     (size_t i = 0; i < index; i++) printf_s("%llu ", arr[i]);

    printf_s("\n");

    // Delete a node
    root                    = eraseBST(root, 50);
    // In-order traversal after deletion
    index                   = 0;

    inorderBST(root, arr, &index);

    printf_s("In-order after deletion: ");

    for                     (size_t i = 0; i < index; i++) printf_s("%llu ", arr[i]);

    printf_s("\n");

    // Free the tree
    freeBST(root);

    // ---- STRING BST ----
    // Insert strings
    BinarySearchTreeString  *rootStr = insertBSTString(NULL, "orange");
    rootStr                 = insertBSTString(rootStr, "orange");
    rootStr                 = insertBSTString(rootStr, "apple");
    rootStr                 = insertBSTString(rootStr, "banana");
    rootStr                 = insertBSTString(rootStr, "grape");
    rootStr                 = insertBSTString(rootStr, "cherry");

    // Count nodes in string BST
    printf_s("Count of BSTString nodes: %u\n", countBSTString(rootStr));

    // In-order traversal
    char                    *strArr[10];
    size_t                  strIndex = 0;

    inorderBSTString(rootStr, strArr, &strIndex);

    printf_s("In-order string traversal: ");

    for                     (size_t i = 0; i < strIndex; i++) printf_s("%s ", strArr[i]);

    printf_s("\n");

    // Delete a string node
    rootStr                 = eraseBSTString(rootStr, "banana");
    // In-order traversal after deletion
    strIndex                = 0;

    inorderBSTString(rootStr, strArr, &strIndex);

    printf_s("In-order string after deletion: ");

    for                     (size_t i = 0; i < strIndex; i++) printf_s("%s ", strArr[i]);

    printf_s("\n");

    // Free the string BST
    freeBSTString(rootStr);
    
    ExitProcess(0);
}