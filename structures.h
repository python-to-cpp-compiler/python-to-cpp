#include <string.h>
#include <stdio.h>
#include <stdlib.h>
struct List {
    struct List* next;
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
void help_print_CalcList(struct CalcList* calc);

struct CalcList* insert(struct CalcList* left, struct CalcList* right, char *op, double value, char* id, char* tmp) {
    struct CalcList* new_val = (struct CalcList*)malloc(sizeof(struct CalcList));
    new_val->left = left;
    new_val->right = right;
    new_val->op = op;
    new_val->value = value;
    new_val->id = id;
    new_val->tmp = tmp;
    help_print_CalcList(new_val);
    return new_val;
}

char* calculate(struct CalcList* calc) {
    if(calc == NULL){}
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

    

    int size = strlen(r1) + strlen(r2) + strlen(calc->left->tmp) + strlen(calc->right->tmp) + strlen(calc->op) + strlen(calc->tmp) + 10;

    res = (char*)malloc(sizeof(char)*size);
    res[0] = 0;

    sprintf(res, "%s%s%s = %s %s %s;\n", r1, r2, calc->tmp, calc->left->tmp, calc->op, calc->right->tmp);

    return res;

}

void help_print_CalcList(struct CalcList* calc){
    printf("left : %p \n right : %p ",calc->left,calc->right);
    if(calc->op == NULL){
        printf("op is null");
    }else{
        printf("op is %s",calc->op);
    }
    if(calc->tmp == NULL){
        printf("tmp is null");
    }else{
        printf("tmp is %s",calc->tmp);
    }
    if(calc->id == NULL){
        printf("id is null");
    }else{
        printf("id is %s",calc->id);
    }
    if(calc->value == 0){
        printf("value is 0");
    }else{
        printf("value is %f",calc->value);
    }
}


struct List* find_by_id_in_tree(struct Tree* tree, char* id){
    if (tree == NULL){
        printf("tree is null\n");
        return NULL;
    }

    struct List* tmp = tree->table;
    while(tmp != NULL){
        if (strcmp(tmp->id, id)){ 
            printf("find value\n");
            return tmp;
        }
        tmp = tmp->next;
    }
    printf("go to parent\n");
    return find_by_id_in_tree(tree->parent, id);
}




struct Tree* make_tree(struct Tree* tree){
    struct Tree* new_tree = (struct Tree*)malloc(sizeof(struct Tree));

    new_tree->parent = tree;

    return new_tree;
}

void free_list(struct List* list){
    if (list == NULL)
        return;

    struct List* tmp = list->next;
    while(tmp != NULL){
        free(list);
        list = tmp;
        tmp = tmp->next;
    }
    free(list);
}


struct Tree* goto_parent(struct Tree* tree){
    struct Tree* tmp = tree->parent;

    free_list(tree->table);
    free(tree);

    return tmp;
}

struct List* insert_in_tree_if_not_exist(struct Tree* tree, char* id){
    struct List* new =find_by_id_in_tree(tree,id) ;
    if (new != NULL)
    {
        return new;
    }
    
    new = (struct List*) malloc(sizeof(struct List));
    new->id = id;
    new->next = NULL;

    struct List* tmp = tree->table;
    if (tmp == NULL){
        tree->table = new;
        return new;
    }
    while (tmp->next != NULL) tmp = tmp->next;

    tmp->next = new;
    return new;

}
