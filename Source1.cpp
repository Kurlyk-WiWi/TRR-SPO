#include <iostream>
#include <string>
#include <sstream>

/*Латинским квадратом порядка n называется квадратная таблица размером nхn,
 * каждая строка и каждый столбец которой содержат все числа от 1 до n.
 * Проверить, является ли заданная целочисленная матрица латинским квадратом.*/

int main() {
    //ввод матрицы
    int n = -1;
    std::cout << "Vvedite razmernost massiva: ";

    while (!(std::cin >> n) || n <= 0) {
        std::cin.clear();
        std::cin.ignore(10000, '\n');
        std::cout << "Vvedite razmernost massiva: ";
    }
    std::cin.ignore(10000, '\n'); // очищаем буфер после ввода числа

    std::cout << "Vvedite massiv " << n << "x" << n << ": " << std::endl;

    // Создаем двумерный массив в динамической памяти
    int** array = new int* [n];
    for (int i = 0; i < n; i++) {
        array[i] = new int[n];
    }

    for (int i = 0; i < n; i++) {
        std::string line;
        std::getline(std::cin, line);
        std::istringstream iss(line);

        for (int j = 0; j < n; j++) {
            iss >> array[i][j];
        }
    }

    bool* st = new bool[n]; //массив упомянутых чисел в квадратной таблице
    bool flag = false; //если true то квадрат не латинский

    //проверка строк
    for (int i = 0; i < n; i++) {
        //очищаем массив строки
        for (int k = 0; k < n; k++) st[k] = false;

        for (int j = 0; j < n; j++) {
            int tmp = array[i][j];
            if (tmp <= 0 || tmp > n) {
                flag = true;
                break;
            }
            if (!st[tmp - 1]) {
                st[tmp - 1] = true;
            }
            else {
                flag = true;
                break; //если одно число встретилось дважды
            }
        }

        if (flag) break;
    }

    if (!flag) {
        //проверка столбцов
        for (int i = 0; i < n; i++) {
            //очищаем массив столбца
            for (int k = 0; k < n; k++) st[k] = false;

            for (int j = 0; j < n; j++) {
                int tmp = array[j][i]; //i и j поменяны местами
                if (tmp <= 0 || tmp > n) {
                    flag = true;
                    break;
                }
                if (!st[tmp - 1]) {
                    st[tmp - 1] = true;
                }
                else {
                    flag = true;
                    break; //если одно число встретилось дважды
                }
            }

            if (flag) break;
        }
    }

    if (flag) {
        std::cout << "Net, ne latinskij kvadrat" << std::endl;
    }
    else {
        std::cout << "Da, eto latinskij kvadrat" << std::endl;
    }

    // Освобождаем память
    for (int i = 0; i < n; i++) {
        delete[] array[i];
    }
    delete[] array;
    delete[] st;

    return 0;
}