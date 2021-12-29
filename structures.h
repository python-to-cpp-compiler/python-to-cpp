#include <string.h>

struct List {
    struct List* next;
    double value;
    char* id;
};

struct Tree {
    struct Tree* parent;
    struct List* table;
};

struct CalcList {
    struct CalcList* left;
    struct CalcList* right;
    char *op;
    double value;
    char* id;
    char* tmp;
};

struct CalcList* insert(struct CalcList* left, struct CalcList* right, char *op, double value, char* id, char* tmp) {
    struct CalcList* new = (struct CalcList*)malloc(sizeof(struct CalcList));
    new->left = left;
    new->right = right;
    new->op = op;
    new->value = value;
    new->id = id;
    new->tmp = tmp;
    return new;
}

char* calculate(struct CalcList* calc) {
    char* res;
    if (calc->op == NULL) {
        if (calc->id == NULL){
            res = (char*)malloc(sizeof(char)*(32+strlen(calc->tmp)));
            sprintf(res, "%s=%f;\n", calc->tmp, calc->value);
            return res;
        }
        else {
            res = (char*)malloc(sizeof(char)*(10+strlen(calc->tmp)+strlen(calc->id)));
            sprintf(res, "%s=%s;\n", calc->tmp, calc->id);
            return res;
        }
    }

    char *r1 = calculate(calc->left);
    char *r2 = calculate(calc->right);

    printf("r1: %s\n", r1);
    printf("r2: %s\n", r2);

    int size = strlen(r1) + strlen(r2) + strlen(calc->left->tmp) + strlen(calc->right->tmp) + strlen(calc->op) + strlen(calc->tmp) + 10;

    res = (char*)malloc(sizeof(char)*size);
    res[0] = 0;

    sprintf(res, "%s%s%s = %s %s %s;\n", r1, r2, calc->tmp, calc->left->tmp, calc->op, calc->right->tmp);
    printf("res: %s\n", res);

    return res;

}

//
// struct List* find_by_id_in_tree(struct Tree* tree, char* id){
//     if (tree == NULL){
//         printf("tree is null\n")
//         return NULL;
//     }
//
//     struct List* tmp = tree->table;
//     while(tmp != NULL){
//         if (strcmp(tmp->id, id)){ // todo check
//             printf("find value\n");
//             return tmp
//         }
//         tmp = tmp->next;
//     }
//     printf("go to parent\n");
//     return find_by_id_in_tree(tree->parent, id);
// }
//
// struct List* change_value_in_tree(struct Tree* tree, char* id, double new_value) {
//     struct List* it = find_by_id_in_tree(tree, id);
//     if (it == NULL) {
//         printf("id not found: %s", id);
//         return NULL;
//     }
//
//     it->value = new_value;
//     return it;
// }
//
//
// struct Tree* make_child(struct Tree* tree){
//     struct Tree* new_tree = (struct Tree*)malloc(sizeof(struct Tree));
//
//     new_tree->parent = tree;
//
//     return new_tree;
// }
//
// void free_list(struct List* list){
//     if (list == NULL)
//         return;
//
//     struct List tmp = list->next;
//     while(tmp != NULL){
//         free(list);
//         list = tmp;
//         tmp = tmp->next;
//     }
//     free(list);
// }
//
//
// struct Tree* goto_parent(struct Tree* tree){
//     struct Tree* tmp = tree->parent;
//
//     free_list(tree->table);
//     free(tree);
//
//     return tmp;
// }
//
// struct List* insert_in_tree(struct Tree* tree, char* id, double value){
//     List* new = (struct List*) malloc(sizeof(struct List));
//     new->id = id;
//     new->value = value;
//     new->next = NULL;
//
//     struct List* tmp = tree->table;
//     if (tmp == NULL){
//         tmp = new;
//         return new;
//     }
//     while (tmp->next != NULL) tmp = tmp->next;
//
//     tmp->next = new;
//     return new;
//
// }
