from passlib.context import CryptContext

class Crypto:
    def __init__(self):
        self.password_context = CryptContext(schemes=["argon2"], deprecated="auto")
        
    def encrypt(self, secret:str):
        return self.password_context.hash(secret)
    
    def decrypt(self, secret:str, hash:str):
        return self.password_context.verify(secret, hash)