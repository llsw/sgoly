package.cpath = "../luaclib/reload/reload.so;"-- .. package.cpath
require "reload"
print(package.path)
print("hello world")
print("hihi")
-- cpath = root.."cservice/?.so;" .. root .. "../luaclib/reload/reload.so;"