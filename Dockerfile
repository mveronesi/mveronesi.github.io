# starting the container from a debian image
FROM ubuntu:latest as HUGO

# adding hugo package
RUN apt update && apt install -y hugo curl

# adding go language to compile the website
RUN curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin

# compiling the website
RUN git clone https://github.com/mveronesi/mveronesi.github.io
RUN hugo -v --source=/mveronesi.github.io/ --destination=/mveronesi.github.io/public

# remove line 30 of the index file
RUN sed -i '30d' /mveronesi.github.io/public/index.html
# remove line 29 column 11 of the index file
RUN sed -i '29 s/.// 11' /mveronesi.github.io/public/index.html

# install nginx, remove the default index file
FROM nginx:stable-alpine
RUN rm /usr/share/nginx/html/index.html
COPY --from=HUGO /mveronesi.github.io/public/ /usr/share/nginx/html/

EXPOSE 80

