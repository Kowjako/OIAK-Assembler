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

extern unsigned long blackwhite(unsigned long n);  //filtr czarno-bialy
extern unsigned long negative(unsigned long n);    //filtr negatyw

extern unsigned long pencil(unsigned long n);    //filtr negatyw

void WriteFile(byte *pixels, int width, int height,int bytesPerPixel) {
        FILE *outputFile = fopen("filtered.bmp", "wb");
        const char *BM = "BM";
        fwrite(&BM[0], 1, 1, outputFile);
        fwrite(&BM[1], 1, 1, outputFile);
        int paddedRowSize = (int)(4 * (int)(((float)(width) / 4.0f) + 1))*bytesPerPixel;
        int fileSize = paddedRowSize*height + HEADER_SIZE + INFO_HEADER_SIZE;
        fwrite(&fileSize, 4, 1, outputFile);
        int reserved = 0x0000;
        fwrite(&reserved, 4, 1, outputFile);
        int dataOffset = HEADER_SIZE+INFO_HEADER_SIZE;
        fwrite(&dataOffset, 4, 1, outputFile);
 
        int infoHeaderSize = INFO_HEADER_SIZE;
        fwrite(&infoHeaderSize, 4, 1, outputFile);
        fwrite(&width, 4, 1, outputFile);
        fwrite(&height, 4, 1, outputFile);
        short planes = 1; 
        fwrite(&planes, 2, 1, outputFile);
        short bitsPerPixel = bytesPerPixel * 8;
        fwrite(&bitsPerPixel, 2, 1, outputFile);
        int compression = NO_COMPRESION;
        fwrite(&compression, 4, 1, outputFile);

        int imageSize = width*height*bytesPerPixel;
        fwrite(&imageSize, 4, 1, outputFile);
        int resolutionX = 11811;
        int resolutionY = 11811; 
        fwrite(&resolutionX, 4, 1, outputFile);
        fwrite(&resolutionY, 4, 1, outputFile);
        int colorsUsed = MAX_NUMBER_OF_COLORS;
        fwrite(&colorsUsed, 4, 1, outputFile);
        int importantColors = ALL_COLORS_REQUIRED;
        fwrite(&importantColors, 4, 1, outputFile);
        int i = 0;
        int unpaddedRowSize = width*bytesPerPixel;
        for ( i = 0; i < height; i++)
        {
            int pixelOffset = ((height - i) - 1)*unpaddedRowSize;
            fwrite(&pixels[pixelOffset], 1, paddedRowSize, outputFile); 
        }
        fclose(outputFile);
}


int main(int argc, char *argv[])
{
    char filelocation[100];
    char temp;
    

    int operation, width, height;

    printf("Podaj nazwę pliku: ");
    scanf("%s", filelocation);

    printf("Wybierz filtr: \n");
    printf("1 - Odcień szarego\n");
    printf("2 - Negatyw \n");
    printf("3 - Czarno-biały \n");
    scanf("%d", &operation);

    printf("Potwierdzenie danych: \n");
    printf("Lokalizacja pliku -> %s\n", filelocation);

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
    fclose(image);

    printf("Ilosc bajtow: %d \n", height*unpaddedRowSize);

    unsigned long arr = 0;
    long encodedArr = 0;

    switch(operation) {
        case 1:
            /* Nakladanie filtru Black-White */
            for(int i=0;i<height*unpaddedRowSize-3;i+=3) {     
                /*Pobieramy pixel*/
                arr = pixels[i];        //pierwszy bajt pixela - R
                arr *= 256;                 
                arr += pixels[i+1];     //drugi bajt pixela - G
                arr *= 256;
                arr += pixels[i+2];     //trzeci bajt pixela - B
                
                encodedArr = blackwhite(arr); //funkcja asm kodujaca pixel na czarnobialy

                /*Nadpisujemy pixel*/
                pixels[i+2]= encodedArr%256;   //zapisujemy nowy pixel RGB
                encodedArr = encodedArr>>8;
                pixels[i+1] = encodedArr%256;
                encodedArr = encodedArr>>8;      
                pixels[i] = encodedArr%256;

                encodedArr = 0;
            } 
            WriteFile(pixels,width,height,bytesPerPixel);
            break;

        case 2:
            /* Nakladanie filtru Negative */
            for(int i=0;i<height*unpaddedRowSize-3;i+=3) {     
                /*Pobieramy pixel*/
                arr = pixels[i];        //pierwszy bajt pixela - R
                arr *= 256;                 
                arr += pixels[i+1];     //drugi bajt pixela - G
                arr *= 256;
                arr += pixels[i+2];     //trzeci bajt pixela - B
                
                encodedArr = negative(arr); //funkcja asm kodujaca pixel na czarnobialy

                /*Nadpisujemy pixel*/
                pixels[i+2]= encodedArr%256;   //zapisujemy nowy pixel RGB
                encodedArr = encodedArr>>8;
                pixels[i+1] = encodedArr%256;
                encodedArr = encodedArr>>8;      
                pixels[i] = encodedArr%256;

                encodedArr = 0;
            } 
            WriteFile(pixels,width,height,bytesPerPixel);
            break;
            
            
        case 3:
            /* Nakladanie filtru olowek */
            for(int i=0;i<height*unpaddedRowSize-3;i+=3) {     
                /*Pobieramy pixel*/
                arr = pixels[i];        //pierwszy bajt pixela - R
                arr *= 256;                 
                arr += pixels[i+1];     //drugi bajt pixela - G
                arr *= 256;
                arr += pixels[i+2];     //trzeci bajt pixela - B
                
                encodedArr = pencil(arr); //funkcja asm kodujaca pixel na czarnobialy

                /*Nadpisujemy pixel*/
                pixels[i+2]= encodedArr%256;   //zapisujemy nowy pixel RGB
                encodedArr = encodedArr>>8;
                pixels[i+1] = encodedArr%256;
                encodedArr = encodedArr>>8;      
                pixels[i] = encodedArr%256;

                encodedArr = 0;
            } 
            WriteFile(pixels,width,height,bytesPerPixel);
            break;
    }
    return 0;
}


