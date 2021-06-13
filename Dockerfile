FROM jfmatth/hugobuilder:latest as HUGO
COPY . /static-site/
RUN hugo -v --source=/static-site --destination=/static-site/public

FROM nginx
COPY --from=HUGO /static-site/public/. /usr/share/nginx/html/
EXPOSE 80
