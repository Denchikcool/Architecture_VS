#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstdio>
using namespace std;

int main(int argc, char* argv[]) {
    string filePath;
    
    if (argc > 1) {
        filePath = argv[1];
    } else {
        char* envFilePath = getenv("FILE_PATH");
        if (envFilePath != nullptr) {
            filePath = envFilePath;
        } else {
            cout << "Путь к файлу не указан." << endl;
            return 0;
        }
    }
    
    ifstream file(filePath);
    
    if (!file) {
        cout << "Не удалось открыть файл: " << filePath << endl;
        return 0;
    }
    
    string line;
    while (getline(file, line)) {
        cout << line << endl;
    }

    getc(stdin);
  
    
    return 0;
}
