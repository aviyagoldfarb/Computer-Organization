//201509635 aviya goldfarb
#include <stdio.h>


/* function name: is_little_endian.
 * the input: no input.
 * the output: 1 or 0.
 * the function operation: the function checks if the computer that runs it is working according to 'little endian'
 * platform (returns 1) or according to 'big endian' platform (returns 0). i defined long variable with the value of 5.
 * that means that it stores in the memory as 8 bytes- 7 bytes all are 0, and 1 byte is 00000101. i defined
 * pointer to char (points to 1 byte), and gave it the address of the long variable- it points to the first byte of
 * the long variable. now there are 2 options: if the computer is working according to 'little endian' (it stores the
 * lsb in the first address) we will find in the pointed address the value of 5, if it works according to 'big endian'
 * (it stores the lsb in the last address) we will find in the pointed address the value of 0.
 */
int is_little_endian() {
    long x = 5L;
    char * pointer = (char*)&x;
    if (*pointer == 5) {
        return 1;
    } else {
        return 0;
    }
}

/* function name: merge_bytes.
 * the input: two unsigned long variables.
 * the output: unsigned long variable that is built from the least significant byte of y, and the rest bytes of x.
 * the function operation: i defined a new unsigned long variable z, that will get the right values. first of all we
 * need to know if our computer is working according to little or big endian. therefor we will use the previous
 * function and we will choose the way of working respectively. the idea in both of the ways is to define one pointer
 * to the least significant byte of y, to assign x into z, to define another pointer to the lsb of z and to assign the
 * pointed lsb value of y into the pointed lsb value of z.
 */
unsigned long merge_bytes(unsigned long x, unsigned long y) {
    unsigned long z;
    if (is_little_endian()) {
        char * pointer1 = (char*)&y;
        z = x;
        char * pointer2 = (char*)&z;
        *pointer2 = *pointer1;
        return z;
    } else {
        char * pointer1 = (char*)&y;
        char * pointer3 = pointer1 + (sizeof(y) - 1);
        z = x;
        char * pointer2 = (char*)&z;
        char * pointer4 = pointer2 + (sizeof(z) - 1);
        *pointer4 = *pointer3;
        return z;
    }
}

/* function name: put_byte.
 * the input: one unsigned long variable, one unsigned char and one integer.
 * the output: unsigned long variable that its i byte is the unsigned char variable and the rest bytes of the unsigned
 * long variable.
 * the function operation: i defined a new unsigned long variable z, that will get the right values. first of all we
 * need to know if our computer is working according to little or big endian. therefor we will use the first
 * function and we will choose the way of working respectively. the idea in both of the ways is to define one pointer
 * to the unsigned char b, to assign x into z, to define another pointer to the i byte of z and to assign the
 * pointed value of b into the pointed i value of z.
 */
unsigned long put_byte(unsigned long x, unsigned char b, int i) {
    unsigned long z;
    if (is_little_endian()) {
        char * pointer1 = &b;
        z = x;
        char * pointer2 = (char*)&z;
        char * pointer3 = pointer2 + i;
        *pointer3 = *pointer1;
        return z;
    } else {
        char * pointer1 = &b;
        z = x;
        char * pointer2 = (char*)&z;
        char * pointer3 = pointer2 + (sizeof(z) -1 -i);
        *pointer3 = *pointer1;
        return z;
    }
}
