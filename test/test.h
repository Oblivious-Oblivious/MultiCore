/*
template<class T1, class T2>
struct pair {
    typedef T1 first_type;
    typedef T2 second_type;
    T1 first;
    T2 second;
    pair();
    pair(const T1&, const T2&);
    ~pair();
};
*/

/*template<class T1, class T2>*/
struct pair {
    /*typedef T1 first_type;*/
    typedef int first_type;
    /*typedef T2 second_type;*/
    typedef int second_type;
    /*
    T1 first;
    T2 second;
    */
    int first;
    int second;
    pair();
    /*pair(const T1&, const T2&);*/
    pair(const int, const int);
    ~pair();
};

