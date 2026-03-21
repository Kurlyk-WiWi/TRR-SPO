# Имя компилятора
CXX ?= g++
# Флаги компиляции: -Wall включает все предупреждения, -std=c++17 указывает стандарт
CXXFLAGS ?= -Wall -std=c++17
# Виртуальная папка для dep-пакета
PKG_DIR = pkg-build
# Исходный файл для компиляции
SRC = Source1.cpp
# Имя итогового исполняемого файла
TARGET = program

all: check $(TARGET)

check:
	@command -v $(CXX) > /dev/null || {echo "Error: $(CXX) not found"; exit 1;}

# Создание исполняемого файла
$(TARGET): $(SRC)
	$(CXX) $(SRC) -o $(TARGET) $(LDFLAGS)
	@echo "Сборка завершена. Исполняемый файл: $(TARGET)"

# Цель "clean" - удаляет все объектные файлы и исполняемый файл
clean:
	rm -f $(TARGET)
	rm -rf $(PKG_DIR)/usr/local/bin/$(TARGET)

# Цель "install" - копирует программу в системную папку (понадобится для deb пакета)
install:
	@install -d $(PKG_DIR)/usr/local/bin
	@cp -r DEBIAN $(PKG_DIR)/
	@cp $(TARGET) $(PKG_DIR)/usr/local/bin
deb: install
	@dpkg-deb --build $(PKG_DIR)


# Объявляем цели, которые не являются файлами
.PHONY: all check clean install deb help 
help:
    @echo "Доступные цели:"
    @echo "  make        	- собрать программу"
	@echo "  make check  	- проверить наличие компилятора g++"
    @echo "  make clean  	- удалить временные файлы"
    @echo "  make install	- подготовить структуру для deb-пакета"
	@echo "  make deb		- собрать deb-пакет"