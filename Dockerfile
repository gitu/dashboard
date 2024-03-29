ARG VERSION=undefined-docker

FROM golang:1.18 AS build-back

WORKDIR /src/
COPY back/go.mod /src/
COPY back/go.sum /src/
RUN go mod download
COPY back /src/
RUN CGO_ENABLED=0 go build -v -ldflags="-X 'github.com/gitu/dashboard/back/pkg/version.Version=${VERSION}'" -o /bin/dashboard ./cmd/dashboard


FROM node:lts-alpine AS build-front

WORKDIR /src/
COPY front/package.json /src/
COPY front/package-lock.json /src/
RUN npm i
COPY front /src/
RUN npm run build


FROM scratch
COPY --from=build-back /bin/dashboard /bin/dashboard
COPY --from=build-front /src/dist /front

ENV STATIC=/front

EXPOSE 1323
ENTRYPOINT ["/bin/dashboard"]