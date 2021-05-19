#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define DATA_OFFSET_OFFSET 0x000A //wskazuje gdzie sie zaczynaja pixele
#define WIDTH_OFFSET 0x0012  //adres szerokosci w naglowku bmp
#define HEIGHT_OFFSET 0x0016    //adres wysokosci w naglowku bmp
#define BITS_PER_PIXEL_OFFSET 0x001C    //bitow na pixel z naglowku bmp
#define HEADER_SIZE 14  
#define INFO_HEADER_SIZE 40
#define NO_COMPRESION 0
#define MAX_NUMBER_OF_COLORS 0
#define ALL_COLORS_REQUIRED 0

typedef unsigned char byte;

unsigned long encoder(unsigned long n,unsigned long msglength); //funkcja asemblera

int main()
{
    char filelocation[100];
    char message[256];
    char temp;
    

    int operation, width, height;

    printf("Podaj nazwę pliku: ");
    scanf("%s", filelocation);

    printf("Wybierz operację: \n");
    printf("1 - Szyfruj \n");
    printf("2 - Deszyfruj \n");
    scanf("%d", &operation);

    switch(operation) {
        case 1:
            printf("Podaj zdanie do szyfrowania: ");
            scanf("%c", &temp);
            scanf("%[^\n]", message);
            printf("Potwierdzenie danych: \n");
            printf("Lokalizacja pliku -> %s\n", filelocation);
            printf("Zdanie do kodowania -> %s\n", message);

            FILE *image = fopen(filelocation,"rb");
            int dataOffset;
            fseek(image, DATA_OFFSET_OFFSET, SEEK_SET);
            fread(&dataOffset, 4, 1, image);

            fseek(image, WIDTH_OFFSET, SEEK_SET);
            fread(&width, 4, 1, image);

            fseek(image, HEIGHT_OFFSET, SEEK_SET);
            fread(&height, 4, 1, image);

            short bitsPerPixel;
            fseek(image, BITS_PER_PIXEL_OFFSET, SEEK_SET);
            fread(&bitsPerPixel, 2, 1, image);

            int bytesPerPixel = ((int)bitsPerPixel) / 8;
            int paddedRowSize = (int)(4 * (int)(((float)(width) / 4.0f) + 1))*bytesPerPixel;
            int unpaddedRowSize = width*bytesPerPixel;

            int totalSize = unpaddedRowSize*height;

            byte* pixels = (byte*)malloc(totalSize);
            byte* currentRowPointer = pixels + (height-1)*unpaddedRowSize;  //wskaznik na ostatni wiersz naszej tablicy pixeli
            for(int i=0;i<height;i++) {
                fseek(image, dataOffset+(i*paddedRowSize), SEEK_SET);
                fread(currentRowPointer, 1, unpaddedRowSize, image);
                currentRowPointer -= unpaddedRowSize;
            }


            printf("Ilosc bajtow: %d \n", height*unpaddedRowSize);
            //Steganografia//
            //10368 - poczatek bajtow pixeli //
            long arr = 0;
            for(int i=10368;i<height*unpaddedRowSize;i+=4) {
                if(i-10368>strlen(message)) break;
                arr = *(&pixels[i]);        //pierwszy bajt pixela
                arr *= 256;             //rownowazne przesunieciu w HEX (00c9->c900)
                arr += *(&pixels[i+1]); //drugi bajt pixela
                arr *= 256;
                arr += *(&pixels[i+2]); //trzeci bajt pixela
                arr *= 256;
                arr += *(&pixels[i+3]); //czwarty bajt pixela
                encoder(arr, message[i-10368]);
                printf("h");
            }


            break;
        case 2:
            
            break;
    }
    return 0;
}


