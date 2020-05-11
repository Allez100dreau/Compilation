struct liste *allouer(struct liste *p) {
  if (p!=0) {
    p->suivant=malloc(sizeof(p));
    return p->suivant;
  } else {
    p=malloc(sizeof(p));
    return p;
  }
}
