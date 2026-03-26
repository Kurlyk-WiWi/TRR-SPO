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
# Ну по приколу
VERSION = 1.0
# Архитектура
ARCH = amd64

all: check $(TARGET)

# Проверка компилятора
check:
	@if ! command -v $(CXX) > /dev/null; then \
		echo "Error: $(CXX) not found"; \
		exit 1; \
	fi

# Создание исполняемого файла
$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET) 
	@echo "Сборка завершена. Исполняемый файл: $(TARGET)"

# Цель "clean" - удаляет все объектные файлы и исполняемый файл
clean:
	rm -f $(TARGET)
	rm -rf $(PKG_DIR)
	rm -f myprogram_$(VERSION)_$(ARCH).deb

# Cоздаёт папки для deb-пакета
prepare-deb:
	@mkdir -p $(PKG_DIR)/usr/local/bin
	@mkdir -p $(PKG_DIR)/DEBIAN
	
#Что-то умное про зависимости
control: 
	@echo "Создание control файла..."
	@echo "Package: myprogram" > $(PKG_DIR)/DEBIAN/control
	@echo "Version: $(VERSION)" >> $(PKG_DIR)/DEBIAN/control
	@echo "Architecture: amd64" >> $(PKG_DIR)/DEBIAN/control
	@echo "Maintainer: Katerina <Morozilka2004@bk.ru>" >> $(PKG_DIR)/DEBIAN/control
	@echo "Description: Program to check if a matrix is a Latin square" >> $(PKG_DIR)/DEBIAN/control
	@echo "Depends: libc6 (>= 2.29)" >> $(PKG_DIR)/DEBIAN/control
	@echo "Готово"
	
# Сборка deb-пакета
deb: clean check $(TARGET) prepare-deb control
	cp $(TARGET) $(PKG_DIR)/usr/local/bin/
	chmod +x $(PKG_DIR)/usr/local/bin/$(TARGET)
	dpkg-deb --build $(PKG_DIR)
	mv $(PKG_DIR).deb myprogram_$(VERSION)_$(ARCH).deb
	@echo "deb-пакет создан: myprogram_$(VERSION)_$(ARCH).deb"
	
# Установка пакета локально
install-local: deb
	@sudo dpkg -i myprogram_$(VERSION)_$(ARCH).deb
	@echo "Программа установлена"
# Удаление пакета локально
remove-local:
	@sudo dpkg -r myprogram

# Объявляем цели, которые не являются файлами
.PHONY: all check clean prepare-deb deb install-local remove-local help 
help:
	@echo "Доступные цели:"
	@echo "  make          		- собрать программу"
	@echo "  make check    		- проверить наличие компилятора g++"
	@echo "  make clean    		- удалить временные файлы"
	@echo "  make prepare-deb   - подготовить структуры пакета"
	@echo "  make control   	- создать control файла"
	@echo "  make deb      		- собрать deb-пакет"
	@echo "  make install-local - установить собранный пакет"
	@echo "  make remove-local  - удалить установленный пакет"