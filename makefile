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
VERSION = 1.0 # Ну по приколу

all: check $(TARGET)

check:
	@command -v $(CXX) > /dev/null || {echo "Error: $(CXX) not found"; exit 1; }

# Создание исполняемого файла
$(TARGET): $(SRC)
	$(CXX) $(SRC) -o $(TARGET) $(LDFLAGS)
	@echo "Сборка завершена. Исполняемый файл: $(TARGET)"

# Цель "clean" - удаляет все объектные файлы и исполняемый файл
clean:
	rm -f $(TARGET)
	rm -rf $(PKG_DIR)

# Cоздаёт папки для deb-пакета
prepare-deb:
	@mkdir -p $(PKG_DIR)/usr/local/bin
	@mkdir -p $(PKG_DIR)/DEBIAN
	
# Создание deb-пакета
deb: clean check $(TARGET) prepare-deb
	@cp $(TARGET) $(PKG_DIR)/usr/local/bin/
	#Что-то умное про зависимости
	@echo "Package: myprogram" > $(PKG_DIR)/DEBIAN/control
	@echo "Version: $(VERSION)" >> $(PKG_DIR)/DEBIAN/control
	@echo "Architecture: amd64" >> $(PKG_DIR)/DEBIAN/control
	@echo "Maintainer: Your Name <your.email@example.com>" >> $(PKG_DIR)/DEBIAN/control
	@echo "Description: Is This Latin Square" >> $(PKG_DIR)/DEBIAN/control
	@echo "Depends: g++ (>= 4:9.2), libc6 (>= 2.29)" >> $(PKG_DIR)/DEBIAN/control
	@echo "Создание deb-пакета..."
	@dpkg-deb --build $(PKG_DIR)
	@mv $(PKG_DIR).deb myprogram_$(VERSION)_amd64.deb
	@echo "Пакет создан: myprogram_$(VERSION)_amd64.deb"

# Установка пакета локально
install-local: deb
	@sudo dpkg -i myprogram_$(VERSION)_amd64.deb
	@echo "Программа установлена"
# Удаление пакета локально
remove-local:
	@sudo dpkg -r myprogram

# Объявляем цели, которые не являются файлами
.PHONY: all check clean prepare-deb deb install-local remove-local help 
help:
	@echo "Доступные цели:"
	@echo "  make          - собрать программу"
	@echo "  make check    - проверить наличие компилятора g++"
	@echo "  make clean    - удалить временные файлы"
	@echo "  make deb      - собрать deb-пакет"
	@echo "  make install-local - установить собранный пакет"
	@echo "  make remove-local - удалить установленный пакет"