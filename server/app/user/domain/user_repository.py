from abc import ABCMeta, abstractmethod
from app.user.domain.user_entity import User

class IUserRepository(metaclass=ABCMeta):
    @abstractmethod
    def save(self, user:User):
        raise NotImplemented
    
    @abstractmethod
    def find_by_email(self, email:str) -> User:
        raise NotImplemented