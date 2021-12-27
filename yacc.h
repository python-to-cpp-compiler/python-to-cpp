struct List {
    struct List* next;
    double value;
    char* id;
}

struct Tree {
    struct Tree* parent;
    struct List* table;
}


List* find_by_id_in_tree(struct Tree* tree, char* id){
    if (tree == NULL){
        printf("tree is null\n")
        return NULL;
    }

    struct List* tmp = tree->table;
    while(tmp != NULL){
        if (strcmp(tmp->id, id)){ // todo check
            printf("find value\n");
            return tmp
        }
        tmp = tmp->next;
    }
    printf("go to parent\n");
    return find_by_id_in_tree(tree->parent, id);
}

struct List* insert_in_tree(struct Tree* tree, char* id, double value){
    List* new = (struct List*) malloc(sizeof(struct List));
    new->id = id;
    new->value = value;
    new->next = NULL;

    struct List* tmp = tree->table;
    if (tmp == NULL){
        tmp = new;
        return new;
    }
    while (tmp->next != NULL) tmp = tmp->next;

    tmp->next = new;
    return new;

}
