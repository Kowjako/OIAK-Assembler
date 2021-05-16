#include <stdio.h>



int main()
{
	char filelocation[100];
	char message[256];
	char temp;

	int operation;

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
    		//algorytm szyfrowania

    		FILE *image = fopen(filelocation,"rb");
    		
    		break;
    	case 2:
    		
    		break;
    }
    return 0;
}


