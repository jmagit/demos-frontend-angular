### STAGE 1: Build ###
FROM node:lts-alpine AS build
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build


### STAGE 2: Deploy ###
FROM nginx:alpine
COPY --from=build /usr/src/app/dist/frontend /usr/share/nginx/html
COPY ./nginx.default.conf /etc/nginx/conf.d/default.conf
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]

# docker build -t angular-server .
# docker run -d --name angular-server -p 4200:80 --network microservicios angular-server
