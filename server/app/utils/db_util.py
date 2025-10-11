from sqlalchemy import inspect
from ulid import ULID

def row_to_dict(row)->dict:
    return {key:getattr(row, key) for key in inspect(row).attrs.keys()}

def generate_ulid() -> str:
    return ULID().generate()