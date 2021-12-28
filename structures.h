struct List {
    struct List* next;
    double value;
    char* id;
}

struct Tree {
    struct Tree* parent;
    struct List* table;
}


struct List* find_by_id_in_tree(struct Tree* tree, char* id){
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

struct List* change_value_in_tree(struct Tree* tree, char* id, double new_value) {
    struct List* it = find_by_id_in_tree(tree, id);
    if (it == NULL) {
        printf("id not found: %s", id);
        return NULL;
    }

    it->value = new_value;
    return it;
}


struct Tree* make_child(struct Tree* tree){
    struct Tree* new_tree = (struct Tree*)malloc(sizeof(struct Tree));

    new_tree->parent = tree;

    return new_tree;
}

void free_list(struct List* list){
    if (list == NULL)
        return;

    struct List tmp = list->next;
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
