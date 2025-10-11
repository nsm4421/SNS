from fastapi import APIRouter, Depends
from dependency_injector.wiring import inject, Provide
from pydantic import BaseModel

from app.dependency_injection import Container
from app.user.application.user_service import UserService

router = APIRouter(prefix="/users", tags=["users"])

class CreateUserBody(BaseModel):
    email:str
    password:str
    name:str

@router.post("", status_code=201)
@inject
def create_user(
    user:CreateUserBody, 
    user_service: UserService = Depends(Provide[Container.user_service])
):
    created_user = user_service.create_user(
        email=user.email,
        password=user.password,
        name=user.name,
    )
    return created_user