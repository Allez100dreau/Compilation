#define TABLE_SIZE 1000

// entrée dans la table
typedef struct entry_t {
    char *key;
    char *value;
    struct entry_t *next;
} entry_t;

// table de hachage
typedef struct {
    entry_t **entries;
} hashtable_t;

unsigned int hash(const char *key);

entry_t *ht_pair(const char *key, const char *value);

hashtable_t *ht_create(void);

void ht_set(hashtable_t *hashtable, const char *key, const char *value);

char *ht_get(hashtable_t *hashtable, const char *key);

void ht_dump(hashtable_t *hashtable);