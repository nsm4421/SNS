from fastapi import HTTPException
from app.database import SessionLocal
from app.user.domain.user_entity import User as UserVo
from app.user.infra.user_model import User
from app.user.domain.user_repository import IUserRepository
from app.utils.db_util import row_to_dict

class UserRepository(IUserRepository):
    def save(self, user:UserVo):
        new_user = User(
            name=user.name,
            email=user.email,
            password=user.password,
            created_at=user.created_at,
            updated_at=user.updated_at
        )
        
        with SessionLocal() as db:
            try:
                db = SessionLocal()
                db.add(new_user)
                db.commit()
            finally:
                db.close()
            
    def find_by_email(self, email:str) -> UserVo:
        
        with SessionLocal() as db:
            user = db.query(User).filter(User.email == email).first()

        if not user:
            raise HTTPException(status_code=422)
        
        return UserVo(
            **row_to_dict(user)
        )