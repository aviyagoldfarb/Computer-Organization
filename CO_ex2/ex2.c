//Aviya goldfarb 201509635
#include <stdio.h>
#include <string.h>

void strightCopy(FILE *source, FILE *target);
void copyByFlags(FILE *source, FILE *target, char *srcFlag, char *trgFlag, int srcEndiannessFlag, int swapFlag);

int main(int argc, char* argv[]) {
    //two file pointers- source and target
    FILE *src, *trg;
    //two char array`s in case of two `flag` arguments
    char srcFlag[5], trgFlag[5];
    //one char array in case of third flag
    char endiannessFlag[5];
    //buffer in order to check the byte order mark of the source file
    char srcEndiannessBom[2];
    /*this flag is equal`s 1 if the src file is written in big endian
      platform, and equal`s 0 if its written in little endian platform*/
    int srcEndiannessFlag;
    //we use these variables in order to swap the srcEndiannessBom if needed
    char temp1 = 0, temp2 = 0;

/* check the number of arguments that passed threw command line and choose the
 * right option respectively*/
switch (argc)
{
    //one argument threw command line- exit the program
    case 2:
        return 0;

    //two arguments threw command line- two files
    case 3:
        //invalid input
        if ((strstr(argv[1], ".") == NULL) || (strstr(argv[2], ".") == NULL)) {
            return 0;
        }
        src = fopen(argv[1], "rb");
        if (src == NULL) {
            return 0;
        }
        trg = fopen(argv[2], "wb");
        strightCopy(src, trg);
        break;

    //three arguments threw command line- exit the program
    case 4:
        return 0;

    //four arguments threw command line- two files and two flags
    case 5:
        //invalid input
        if ((strstr(argv[1], ".") == NULL) || (strstr(argv[2], ".") == NULL)
            || strcmp(argv[4], "-swap") == 0) {
            return 0;
        }
        src = fopen(argv[1], "rb");
        if (src == NULL) {
            return 0;
        }
        trg = fopen(argv[2], "wb");
        strcpy(srcFlag, argv[3]);
        strcpy(trgFlag, argv[4]);
        //checking the byte order mark of the source file
        fread(srcEndiannessBom, sizeof(char), 2, src);
        if (srcEndiannessBom[0] != -1) {
            // source file is swap
            srcEndiannessFlag = 1;
        }
        else {
            //regular source file
            srcEndiannessFlag = 0;
        }
        fwrite(srcEndiannessBom, sizeof(char), 2, trg);

        /*if the two flags are identical, we can just use the `strightCopy`
         * function from `case 3` because we dont need to change anything in
         * the line endings
         */
        if (strcmp(srcFlag, trgFlag) == 0) {
            strightCopy(src, trg);
        }
        //if the two flags are different we will use the `copyByFlags` function
        else {
            copyByFlags(src, trg, srcFlag, trgFlag, srcEndiannessFlag, 0);
        }
        break;

    //five arguments threw command line- two files, two flags and one command
    case 6:
        //invalid input
        if ((strstr(argv[1], ".") == NULL) || (strstr(argv[2], ".") == NULL)
            || (strcmp(argv[4], "-swap") == 0) || ((strcmp(argv[5], "-swap") != 0)
                                                   && (strcmp(argv[5], "-keep") != 0))) {
            return 0;
        }
        src = fopen(argv[1], "rb");
        if (src == NULL) {
            return 0;
        }
        trg = fopen(argv[2], "wb");
        strcpy(srcFlag, argv[3]);
        strcpy(trgFlag, argv[4]);
        strcpy(endiannessFlag, argv[5]);

        /*if the flag endiannessFlag is equal to "-keep" it means we should keep
         *the endianness of the source file, so we can do exactly the same
         * operations of `case 5`
         */
        if (strcmp(endiannessFlag, "-keep") == 0) {
            //checking the byte order mark of the source file
            fread(srcEndiannessBom, sizeof(char), 2, src);
            if (srcEndiannessBom[0] != -1) {
                // source file is swap
                srcEndiannessFlag = 1;
            }
            else {
                //regular source file
                srcEndiannessFlag = 0;
            }
            fwrite(srcEndiannessBom, sizeof(char), 2, trg);

            /*if the two flags are identical, we can just use the `strightCopy`
             * function from `case 3` because we dont need to change anything in
             * the line endings
             */
            if (strcmp(srcFlag, trgFlag) == 0) {
                strightCopy(src, trg);
            }
            //if the two flags are different we will use the `copyByFlags` function
            else {
                copyByFlags(src, trg, srcFlag, trgFlag, srcEndiannessFlag, 0);
            }
        }
        /*if the flag endiannessFlag is equal to "-swap" it means we should swap
         *the endianness of the source file
         */
        if (strcmp(endiannessFlag, "-swap") == 0) {
            //checking the byte order mark of the source file
            fread(srcEndiannessBom, sizeof(char), 2, src);
            if (srcEndiannessBom[0] != -1) {
                // source file is swap
                srcEndiannessFlag = 1;
            }
            else {
                //regular source file
                srcEndiannessFlag = 0;
            }
            temp1 = srcEndiannessBom[0];
            temp2 = srcEndiannessBom[1];
            srcEndiannessBom[0] = temp2;
            srcEndiannessBom[1] = temp1;
            fwrite(srcEndiannessBom, sizeof(char), 2, trg);
            copyByFlags(src, trg, srcFlag, trgFlag, srcEndiannessFlag, 1);
        }
        break;
    dafault:
        break;
}
    fclose(src);
    fclose(trg);
    return 0;
}

/* function name: strightCopy.
 * the input: two files- source and target.
 * the output: no `returned` output, creating new written file.
 * the function operation: copies the source file into the target file char by
 * char using char buffer. in every iteration of the while loop one char from
 * the source file is copied to the target file, until there is no more what
 * to read- then the while loop stops, and we have a copy of the source file.
 */
void strightCopy(FILE *source, FILE *target) {
    char buffer;
    /*`retval` gets the returned value of the `fread` function. it will use us
     * for checking if we ended the reading from the source file.
     */
    int retval;
    do {
        retval = fread(&buffer, sizeof(char), 1, source);
        /*if there is no more what to read from the source file break out of
        the loop
         */
        if (retval != 1) {
            break;
        }
        fwrite(&buffer, sizeof(char), 1, target);
    } while(retval == 1);
}

/* function name: copyByFlags.
 * the input: two files- source and target, and four flags- two flags for
 * operation systems of source and target files, one flag for source file
 * shape (swap or regular) and one flag for `swap` or keep.
 * the output: no `returned` output, creating new written file.
 * the function operation: copies the source file into the target file two
 * chars by two chars using two char buffer. in every iteration of the while
 * loop two chars from the source file are copied to the target file, until
 * there is no more what to read- then the while loop stops, and we have a copy
 * of the source file. while reading, the function replaces the sign of the
 * line ending if needed, according to the flags.
 */
void copyByFlags(FILE *source, FILE *target, char *srcFlag, char *trgFlag, int srcEndiannessFlag, int swapFlag) {
    char buffer[2];
    char temp1 = 0, temp2 = 0;
    /*`retval` gets the returned value of the `fread` function. it will use us
     * for checking if we ended the reading from the source file.
     */
    int retval;
    /* these arrays will get the appropriate information about the sign of the
     * line endings needed to replace, and the sign of the line endings needed
     * to replace to, according to the flags
     */
    char toReplace1[2];
    char toReplace2[2];
    char replaceTo1[2];
    char replaceTo2[2];

    //line endings needed to replace- regular source file
    if  (srcEndiannessFlag == 0) {
        if (strcmp(srcFlag, "-win") == 0) {
            toReplace1[0] = 0x0d;
            toReplace1[1] = 0x00;

            toReplace2[0] = 0x0a;
            toReplace2[1] = 0x00;
        }
        if (strcmp(srcFlag, "-unix") == 0) {
            toReplace1[0] = 0x0a;
            toReplace1[1] = 0x00;

            toReplace2[0] = 0x00;
            toReplace2[1] = 0x00;
        }
        if (strcmp(srcFlag, "-mac") == 0) {
            toReplace1[0] = 0x0d;
            toReplace1[1] = 0x00;

            toReplace2[0] = 0x00;
            toReplace2[1] = 0x00;
        }

        //line endings needed to replace to- regular source file
        if (strcmp(trgFlag, "-win") == 0) {
            replaceTo1[0] = 0x0d;
            replaceTo1[1] = 0x00;

            replaceTo2[0] = 0x0a;
            replaceTo2[1] = 0x00;
        }
        if (strcmp(trgFlag, "-unix") == 0) {
            replaceTo1[0] = 0x0a;
            replaceTo1[1] = 0x00;
            //we give replaceTo2 this value in order to use it later in the conditions
            replaceTo2[0] = 0x00;
            replaceTo2[1] = 0x00;
        }
        if (strcmp(trgFlag, "-mac") == 0) {
            replaceTo1[0] = 0x0d;
            replaceTo1[1] = 0x00;
            //we give replaceTo2 this value in order to use it later in the conditions
            replaceTo2[0] = 0x00;
            replaceTo2[1] = 0x00;
        }
    }
    //line endings needed to replace- source file is swap
    if  (srcEndiannessFlag == 1) {
        if (strcmp(srcFlag, "-win") == 0) {
            toReplace1[0] = 0x00;
            toReplace1[1] = 0x0d;

            toReplace2[0] = 0x00;
            toReplace2[1] = 0x0a;
        }
        if (strcmp(srcFlag, "-unix") == 0) {
            toReplace1[0] = 0x00;
            toReplace1[1] = 0x0a;

        }
        if (strcmp(srcFlag, "-mac") == 0) {
            toReplace1[0] = 0x00;
            toReplace1[1] = 0x0d;

        }

        //line endings needed to replace to- source file is swap
        if (strcmp(trgFlag, "-win") == 0) {
            replaceTo1[0] = 0x00;
            replaceTo1[1] = 0x0d;

            replaceTo2[0] = 0x00;
            replaceTo2[1] = 0x0a;
        }
        if (strcmp(trgFlag, "-unix") == 0) {
            replaceTo1[0] = 0x00;
            replaceTo1[1] = 0x0a;
            //we give replaceTo2 this value in order to use it later in the conditions
            replaceTo2[0] = 0x00;
            replaceTo2[1] = 0x00;
        }
        if (strcmp(trgFlag, "-mac") == 0) {
            replaceTo1[0] = 0x00;
            replaceTo1[1] = 0x0d;
            //we give replaceTo2 this value in order to use it later in the conditions
            replaceTo2[0] = 0x00;
            replaceTo2[1] = 0x00;
        }
    }

    do {
        retval = fread(buffer, sizeof(char), 2, source);
        /*if there is no more what to read from the source file break out of
        the loop
         */
        if (retval != 2) {
            break;
        }
        //two flags in src file
        if (((toReplace2[0] == 0x0a) && (toReplace2[1] == 0x00)) || ((toReplace2[0] == 0x00) && (toReplace2[1] == 0x0a))) {
            if (toReplace1[0] == buffer[0] && toReplace1[1] == buffer[1]) { //buffer read toReplace1
                buffer[0] = replaceTo1[0];
                buffer[1] = replaceTo1[1];
            } else {
                if (toReplace2[0] == buffer[0] && toReplace2[1] == buffer[1]) { //buffer read toReplace2
                    if (replaceTo2[0] != 0x00 || replaceTo2[1] != 0x00) { //two flags in trg file
                        buffer[0] = replaceTo2[0];
                        buffer[1] = replaceTo2[1];
                    } else { //one flag in trg file
                        // dont write anything- continue to next iteration
                        continue;
                    }
                }
            }
        } // end of if(*toReplace2 = 0x000a)
        //only one flag in src file
        else {
           if (replaceTo2[0] != 0x00 || replaceTo2[1] != 0x00){ //two flags in trg file
               if (toReplace1[0] == buffer[0] && toReplace1[1] == buffer[1]) {
                   buffer[0] = replaceTo1[0];
                   buffer[1] = replaceTo1[1];
                   //swap the endianness order
                   if (swapFlag) {
                       temp1 = buffer[0];
                       temp2 = buffer[1];
                       buffer[0] = temp2;
                       buffer[1] = temp1;
                   }
                   /*writing replaceTo1 into the target file immediately in
                    order to assign replaceTo2 into buffer too*/
                   fwrite(buffer, sizeof(char), 2, target);
                   /*the writing of replaceTo2 into the target file will be
                    in the next performance of fwrite */
                   buffer[0] = replaceTo2[0];
                   buffer[1] = replaceTo2[1];

               }
           }
           else { //one flag in trg file
               if (toReplace1[0] == buffer[0] && toReplace1[1] == buffer[1]) {
                   buffer[0] = replaceTo1[0];
                   buffer[1] = replaceTo1[1];
               }
           }
        }
        //swap the endianness order
        if (swapFlag) {
            temp1 = buffer[0];
            temp2 = buffer[1];
            buffer[0] = temp2;
            buffer[1] = temp1;
        }
        fwrite(buffer, sizeof(char), 2, target);
    } while(retval == 2);
}
