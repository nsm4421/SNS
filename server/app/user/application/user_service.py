from fastapi import HTTPException
from ulid import ULID
from datetime import datetime
from app.user.domain.user_repository import IUserRepository
from app.user.domain.user_entity import User
from app.utils.crypto import Crypto

class UserService:
    def __init__(self, repository:IUserRepository):
        self.ulid = ULID()
        self.repository = repository
        self.crypto = Crypto()
        
    def create_user(self, name:str, email:str, password:str):
        _user = None
        
        try:
            _user = self.repository.find_by_email(email)
        except HTTPException as e:
            if e.status_code != 422:    # 중복된 이메일로 인한 오륙 아닌 경우 -> 알수 없는 오류
                raise e
        
        if _user:
            raise HTTPException(status_code=422, detail="email is duplicated")
        
        now = datetime.now()
        user = User(
            id=self.ulid.generate(),
            name=name,
            email=email,
            password=self.crypto.encrypt(password), # 패스워드 암호화
            created_at=now,
            updated_at=now
        )
        self.repository.save(user)
        return user
            