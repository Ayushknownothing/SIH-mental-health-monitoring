from pydantic import BaseModel


class VictimCreate(BaseModel):
    language: str