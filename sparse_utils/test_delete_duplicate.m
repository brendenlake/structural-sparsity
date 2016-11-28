A = [1 1 1;
    2 2 2;
    3 3 3;
    1 1 1;
    4 4 4;
    2 2 2;
    5 5 5];

T1 = delete_duplicate(A,1);
assert(isequal(T1,A([1 2 3 5 7],:)));

T2 = delete_duplicate(A,2);
assert(isequal(T2,A(:,1)));

A = [1 nan 1;
     1 nan 1];

Q1 = delete_duplicate(A,1);

fprintf(1,'Tests of delete_duplicate passed\n');