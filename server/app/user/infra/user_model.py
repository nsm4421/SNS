from datetime import datetime
from sqlalchemy import DateTime, String, func
from app.database import Base
from sqlalchemy.orm import Mapped, mapped_column

from app.utils.db_util import generate_ulid

class User(Base):
    __tablename__="users"
    
    id: Mapped[str] = mapped_column(
        String(26),  # ULID는 26자
        primary_key=True,
        default=generate_ulid,
    )
    name:Mapped[str]=mapped_column(String(32), nullable=False)
    email:Mapped[str]=mapped_column(String(64), nullable=False, unique=True)
    password:Mapped[str]=mapped_column(String(255), nullable=False)
    created_at:Mapped[datetime]=mapped_column(DateTime, nullable=False, server_default=func.now(),)
    updated_at:Mapped[datetime]=mapped_column(DateTime, nullable=False, server_default=func.now(), onupdate=func.now())