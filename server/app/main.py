from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from app.dependency_injection import Container
from app.user.interface.user_controller import router as user_router

def create_app() -> FastAPI:
    app = FastAPI(title="FastAPI Clean Example")

    container = Container()
    app.container = container  # (테스트 시에도 접근 가능)

    app.include_router(user_router)

    return app


app = create_app()