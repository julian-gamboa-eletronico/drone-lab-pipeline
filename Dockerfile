FROM mcr.microsoft.com/playwright:v1.56.1-jammy
WORKDIR /app

COPY package.json .
RUN npm install

COPY . .

RUN mkdir -p /app && chown -R 1000:1000 /app
USER 1000

CMD ["bash"]
