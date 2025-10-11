from dependency_injector import containers, providers

from app.user.application.user_service import UserService
from app.user.infra.user_repository import UserRepository

class Container(containers.DeclarativeContainer):
    wiring_config = containers.WiringConfiguration(
        packages=['app.user.interface.user_controller']
    )
    
    user_repository=providers.Factory(UserRepository)
    user_service=providers.Factory(UserService, repository=user_repository)
    