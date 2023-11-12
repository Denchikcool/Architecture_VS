FROM ubuntu:latest

RUN apt-get update && apt-get install -y g++

COPY lab2.cpp /src/lab2.cpp
COPY text.txt /src/text.txt

RUN g++ -o /src/lab2 /src/lab2.cpp

CMD ["/src/lab2", "/src/text.txt"]
