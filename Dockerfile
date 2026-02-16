FROM node:20-alpine

WORKDIR /usr/src/app

# sqlite3 needs build tools on Alpine
RUN apk add --no-cache python3 make g++ sqlite-dev

COPY package*.json ./

RUN npm install --omit=dev

COPY . .

EXPOSE 3000

# Use the correct start file for your repo:
# If your repo starts with src/index.js, keep this:
CMD ["node", "src/index.js"]
