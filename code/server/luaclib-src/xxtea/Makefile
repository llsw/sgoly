# Use your path
SKYNET_PATH = ../../skynet
TARGET = ../../luaclib/xxtea.so

$(TARGET) : lua-xxtea.c xxtea.c
	gcc -Wall -g --shared -fPIC -o $@ $^ -I$(SKYNET_PATH)/skynet-src -I ./ -I$(SKYNET_PATH)/3rd/lua

clean :
	rm $(TARGET)

