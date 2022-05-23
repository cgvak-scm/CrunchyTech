FROM node:16
WORKDIR /usr/src/padzilla
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
COPY package.json /usr/src/padzilla/
RUN npm install
COPY . /usr/src/padzilla/
CMD npm start