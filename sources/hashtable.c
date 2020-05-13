#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

// entrée dans la table
typedef struct entry_t
{
    char *key;
    char *value;
    struct entry_t *next;
} entry_t;

// table de hachage
typedef struct
{
    entry_t **entries;
} hashtable_t;

// fonction de hachage
unsigned int hash(const char *key)
{
    unsigned int value = 0;
    unsigned int i = 0;
    unsigned int key_len = strlen(key);

    // on multiplie quelques fois
    for (; i < key_len; i++)
    {
        value = value * 17 + key[i];
    }

    // on s'assure que value est 0 <= value < TABLE_SIZE
    value = value % TABLE_SIZE;

    return value;
}

//on crée une paire (clé, valeur)
entry_t *ht_pair(const char *key, const char *value)
{
    // on alloue la mémoire pour l'entrée
    entry_t *entry = malloc(sizeof(entry_t) * 1);
    entry->key = malloc(strlen(key) + 1);
    entry->value = malloc(strlen(value) + 1);

    // on copie la clé et la valeur
    strcpy(entry->key, key);
    strcpy(entry->value, value);

    // la prochaine entrée est NULL
    entry->next = NULL;

    return entry;
}

// création de la table
hashtable_t *ht_create(void)
{
    // on alloue la mémoire pour la table
    hashtable_t *hashtable = malloc(sizeof(hashtable_t *) * TABLE_SIZE);

    // même chose pour les entrées
    hashtable->entries = malloc(sizeof(entry_t *) * TABLE_SIZE);

    // on met tous les pointeurs à NULL
    int i = 0;
    for (; i < TABLE_SIZE; i++)
    {
        hashtable->entries[i] = NULL;
    }

    return hashtable;
}

// insertion d'un élément dans la table
void ht_set(hashtable_t *hashtable, const char *key, const char *value)
{
    unsigned int slot = hash(key);

    // on regarde s'il y a quelque chose
    entry_t *entry = hashtable->entries[slot];

    // s'il n'y a rien, on insère
    if (entry == NULL)
    {
        hashtable->entries[slot] = ht_pair(key, value);
        return;
    }

    entry_t *previous;

    while (entry != NULL)
    {
        // on regarde la clé
        if (strcmp(entry->key, key) == 0)
        {
            // on a trouvé la clé, on remplace la valeur
            free(entry->value);
            entry->value = malloc(strlen(value) + 1);
            strcpy(entry->value, value);
            return;
        }

        // on va au suivant
        previous = entry;
        entry = previous->next;
    }

    // on a atteint la fin sans trouver la clé, on crée une nouvelle paire
    previous->next = ht_pair(key, value);
}

// obtenir un élément dans la table
char *ht_get(hashtable_t *hashtable, const char *key)
{
    unsigned int slot = hash(key);

    // on essaie de trouver un emplacement valide
    entry_t *entry = hashtable->entries[slot];

    // s'il n'y a pas d'emplacement, alors il n'y a pas d'entrée
    if (entry == NULL)
    {
        return NULL;
    }

    // on parcourt les entrées à l'emplacement donné
    while (entry != NULL)
    {
        // si on trouve la clé, on retourne la valeur
        if (strcmp(entry->key, key) == 0)
        {
            return entry->value;
        }

        // on passe à l'entrée suivante si elle est disponible
        entry = entry->next;
    }

    // il y avait au moins une entrée mais aucune correspondance de clé
    return NULL;
}

// afficher la table
void ht_dump(hashtable_t *hashtable)
{
    for (int i = 0; i < TABLE_SIZE; ++i)
    {
        entry_t *entry = hashtable->entries[i];

        if (entry == NULL)
        {
            continue;
        }

        printf("slot[%d]: ", i);

        for (;;)
        {
            printf("%s=%s ", entry->key, entry->value);

            if (entry->next == NULL)
            {
                break;
            }

            entry = entry->next;
        }

        printf("\n");
    }
}