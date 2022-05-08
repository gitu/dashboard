package main

import (
	"github.com/labstack/echo/v4/middleware"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/api/hello", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World! - "+echo.Version)
	})
	e.Use(middleware.RequestID())
	e.Use(middleware.Logger())
	e.Use(middleware.Static(staticDir()))
	e.Logger.Fatal(e.Start(":1323"))
}

func staticDir() string {
	env, b := os.LookupEnv("STATIC")
	if !b {
		env = "front/dist/"
	}
	return env
}
