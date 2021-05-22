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

extern unsigned long encoder(unsigned long n,unsigned long msglength); //funkcja asemblera
extern unsigned long decoder(unsigned long n);

void WriteFile(byte *pixels, int width, int height,int bytesPerPixel) {
        FILE *outputFile = fopen("gg.bmp", "wb");
        //*****HEADER************//
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
 
        //*******INFO*HEADER******//
        int infoHeaderSize = INFO_HEADER_SIZE;
        fwrite(&infoHeaderSize, 4, 1, outputFile);
        fwrite(&width, 4, 1, outputFile);
        fwrite(&height, 4, 1, outputFile);
        short planes = 1; //always 1
        fwrite(&planes, 2, 1, outputFile);
        short bitsPerPixel = bytesPerPixel * 8;
        fwrite(&bitsPerPixel, 2, 1, outputFile);
        //write compression
        int compression = NO_COMPRESION;
        fwrite(&compression, 4, 1, outputFile);

        int imageSize = width*height*bytesPerPixel;
        fwrite(&imageSize, 4, 1, outputFile);
        int resolutionX = 11811; //300 dpi
        int resolutionY = 11811; //300 dpi
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

void showString(char* str) {
    for(int j=1;j<strlen(str);j++)
        printf("%c",str[j]);
    printf("\n");
}

void DecodeFile(char* filename) {

        int width, height;
        FILE *image = fopen(filename,"rb");

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

        long arr = 0;
        long decodedArr = 0;

        arr = pixels[0];        //pierwszy bajt pixela
        arr *= 256;                 //rownowazne przesunieciu w HEX (00c9->c900)
        arr += pixels[1];       //drugi bajt pixela
        arr *= 256;
        arr += pixels[2];       //trzeci bajt pixela
        arr *= 256;
        arr += pixels[3];       //czwarty bajt pixela


        long x = 0; 
        long length = decoder(arr);
        // Konwertowanie z postaci szesnastkowej //
        int factLength = 1*length % 256;
        length /= 256;
        factLength += 4* length%256;
        length /= 256;
        factLength += 16*length%256;
        length /= 256;
        factLength += 64*length%256;

        long decoded = 0, j=0;
        arr = 0;

        char b[255];

        for(int i = 10368; i< (factLength*4+10368) + 4;i+=4) {
            arr = pixels[i];        //pierwszy bajt pixela
            arr *= 256;                 //rownowazne przesunieciu w HEX (00c9->c900)
            arr += pixels[i+1];     //drugi bajt pixela
            arr *= 256;
            arr += pixels[i+2];     //trzeci bajt pixela
            arr *= 256;
            arr += pixels[i+3];     //czwarty bajt pixela

            decoded = decoder(arr);
            long factSymbol = decoded % 256;
            decoded /= 256;
            factSymbol += 4* decoded % 256;
            decoded /= 256;
            factSymbol += 16 *decoded %256;
            decoded /= 256;
            factSymbol += 64*decoded%256;

            j++;

            b[j] = factSymbol;
        }

        showString(b);
            
}

int main(int argc, char *argv[])
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
            fclose(image);

            printf("Ilosc bajtow: %d \n", height*unpaddedRowSize);
            //Steganografia//
            //10368 - poczatek bajtow pixeli sprawdzone w GDB//
            unsigned long arr = 0;
            long encodedArr = 0;
                        
            int sizeMsg = strlen(message)-1;
            int j = 1;

            arr = pixels[0];        //pierwszy bajt pixela
            arr *= 256;                 //rownowazne przesunieciu w HEX (00c9->c900)
            arr += pixels[1];       //drugi bajt pixela
            arr *= 256;
            arr += pixels[2];       //trzeci bajt pixela
            arr *= 256;
            arr += pixels[3];       //czwarty bajt pixela
                
            encodedArr = encoder(arr, sizeMsg); //kodujemy dlugosc ciagu
            arr+=0;
            //Kodowanie dlugosci//
            pixels[3] = encodedArr%256;   //dzielenie przez 100 (256 HEX) rownowazne wzieciu dwoch ostatnich liter(1 bajt)
            encodedArr = encodedArr>>8;     //przesuwamy do kolejnego bajtu
            pixels[2]= encodedArr%256;   //kolejne dwie litery
            encodedArr = encodedArr>>8;
            pixels[1] = encodedArr%256;
            encodedArr = encodedArr>>8;      
            pixels[0] = encodedArr%256;

            for(int i=10368;i<height*unpaddedRowSize;i+=4) {
                if(j-1>sizeMsg) break;
                
                arr = pixels[i];        //pierwszy bajt pixela
                arr *= 256;                 //rownowazne przesunieciu w HEX (00c9->c900)
                arr += pixels[i+1];     //drugi bajt pixela
                arr *= 256;
                arr += pixels[i+2];     //trzeci bajt pixela
                arr *= 256;
                arr += pixels[i+3];     //czwarty bajt pixela
                
                encodedArr = encoder(arr, message[j-1]); //funkcja asemblera kodujaca jeden symbol na 4 bajtach pixeli
                j++;

                pixels[i+3] = encodedArr%256;   //dzielenie przez 100 (256 HEX) rownowazne wzieciu dwoch ostatnich liter(1 bajt)
                encodedArr = encodedArr>>8;     //przesuwamy do kolejnego bajtu
                pixels[i+2]= encodedArr%256;   //kolejne dwie litery
                encodedArr = encodedArr>>8;
                pixels[i+1] = encodedArr%256;
                encodedArr = encodedArr>>8;      
                pixels[i] = encodedArr%256;

                encodedArr = 0;
            } 

            WriteFile(pixels,width,height,bytesPerPixel);


            break;
        case 2:
            //Otwieramy plik do deszyfrowania
            DecodeFile(filelocation);
            
            
            break;
    }
    return 0;
}


