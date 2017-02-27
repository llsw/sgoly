# Use your path
SKYNET_PATH = ../../skynet
TARGET = ../../luaclib/skynet-reload/reload.so

$(TARGET) : lua-reload.c
	gcc -Wall -g --shared -fPIC -o $@ $^ -I$(SKYNET_PATH)/skynet-src

clean :
	rm $(TARGET)
