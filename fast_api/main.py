from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

@app.on_event("startup")
async def startup_event():
    print("Application started!")
    app.data = []

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello")
async def hello():
    return app.data

class Person(BaseModel):
    uuid: str
    name: str
    age: int

@app.Post("/hello")
async def hello(person: Person):
    app.data.append(person)
    return person