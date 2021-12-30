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
struct List* insert_in_tree_if_not_exist(struct Tree* tree, char* id);
struct List* find_by_id_in_tree(struct Tree* tree, char* id);

struct CalcList* insert(struct CalcList* left, struct CalcList* right, char *op, double value, char* id, char* tmp) {
    struct CalcList* new_val = (struct CalcList*)malloc(sizeof(struct CalcList));
    new_val->left = left;
    new_val->right = right;
    new_val->op = op;
    new_val->value = value;
    new_val->id = id;
    new_val->tmp = tmp;
    return new_val;
}


void free_calclist(struct CalcList* item){
    if(item->op == NULL){
        if(item->id != NULL){
            free(item->id);
        }
        
    }else{
        free_calclist(item->left);
        free_calclist(item->right);
        free(item->op);
    }

    free(item);
}

char* calculate(struct CalcList* calc,struct Tree* tree) {
    char* doubleDeclartion = "";
    int size = 0;
    char* res;
    
    
    if (calc->op == NULL) {
        if(find_by_id_in_tree(tree,calc->tmp) == NULL){
                insert_in_tree_if_not_exist(tree,calc->tmp);
                size = 10;
                doubleDeclartion = "double ";
            }

        if (calc->id == NULL){
            
            size += 40+strlen(calc->tmp);
            res = (char*)malloc(sizeof(char)*size);
          
            sprintf(res, "%s%s=%f;\n",doubleDeclartion, calc->tmp, calc->value);
            
            
        }
        else {
            char* declerId = "";
            if(find_by_id_in_tree(tree,calc->id) == NULL){
                insert_in_tree_if_not_exist(tree,calc->id);
                size+= (10+strlen(calc->id));
                declerId = (char*)malloc(10+strlen(calc->id));
                sprintf(declerId ,"double %s;\n",calc->id);
            }

            size+= (10+strlen(calc->tmp)+strlen(calc->id));
            res = (char*)malloc(sizeof(char)*size);
            sprintf(res, "%s%s%s=%s;\n", declerId,doubleDeclartion,calc->tmp, calc->id);
            
        }
        return res;
    }

    if (strcmp(calc->op,"!") == 0)
    {
        char *r1 = calculate(calc->left,tree);
        size = strlen(r1)  + strlen(calc->left->tmp) + strlen(calc->op) + strlen(calc->tmp) + 10;
        if(find_by_id_in_tree(tree,calc->tmp) == NULL){
            insert_in_tree_if_not_exist(tree,calc->tmp);
            doubleDeclartion = "double ";
            size += 10;
        }
        res = (char*)malloc(sizeof(char)*size);
        
        res[0] = 0;

        sprintf(res, "%s%s %s = %s %s;\n", r1, doubleDeclartion,calc->tmp,  calc->op, calc->left->tmp);

        return res;
    }
    

    char *r1 = calculate(calc->left,tree);
    char *r2 = calculate(calc->right,tree);

    

    size = strlen(r1) + strlen(r2) + strlen(calc->left->tmp) + strlen(calc->right->tmp) + strlen(calc->op) + strlen(calc->tmp) + 10;
    if(find_by_id_in_tree(tree,calc->tmp) == NULL){
        insert_in_tree_if_not_exist(tree,calc->tmp);
        doubleDeclartion = "double ";
        size += 10;
        }
    res = (char*)malloc(sizeof(char)*size);
    
    res[0] = 0;

    sprintf(res, "%s%s%s %s = %s %s %s;\n", r1, r2,doubleDeclartion,calc->tmp, calc->left->tmp, calc->op, calc->right->tmp);

    return res;

}

void help_print_CalcList(struct CalcList* calc){
    printf("left : %p \n right : %p\n",calc->left,calc->right);
    if(calc->op == NULL){
        printf("op is null\n");
    }else{
        printf("op is %s\n",calc->op);
    }
    if(calc->tmp == NULL){
        printf("tmp is null\n");
    }else{
        printf("tmp is %s\n",calc->tmp);
    }
    if(calc->id == NULL){
        printf("id is null\n");
    }else{
        printf("id is %s\n",calc->id);
    }
    if(calc->value == 0){
        printf("value is 0\n");
    }else{
        printf("value is %f\n",calc->value);
    }
    printf("==============================================\n");
}


struct List* find_by_id_in_tree(struct Tree* tree, char* id){
    
    if (tree == NULL){
        return NULL;
    }

    struct List* tmp = tree->table;
    while(tmp != NULL){
     
        if (strcmp(tmp->id, id) == 0){ 
            return tmp;
        }
        tmp = tmp->next;
    }
    return find_by_id_in_tree(tree->parent, id);
}




struct Tree* make_tree(struct Tree* tree){
    struct Tree* new_tree = (struct Tree*)malloc(sizeof(struct Tree));

    new_tree->parent = tree;
    new_tree->table = NULL;
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
    while (tmp->next != NULL) {
        tmp = tmp->next;
        }
    tmp->next = new;
    return new;

}
