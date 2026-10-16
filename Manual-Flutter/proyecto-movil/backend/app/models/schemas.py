from pydantic import BaseModel, ConfigDict, Field, field_validator


class UserInput(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
    nombre: str = Field(min_length=1, max_length=100)
    correo: str = Field(min_length=3, max_length=150, pattern=r"^[^\s@]+@[^\s@]+\.[^\s@]+$")

    @field_validator("correo")
    @classmethod
    def normalize_email(cls, value):
        return value.lower()


class TaskInput(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
    title: str = Field(min_length=1, max_length=200)
    completed: bool = Field(default=False, strict=True)
    category_id: int | None = Field(default=None, gt=0, strict=True)
