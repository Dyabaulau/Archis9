from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from pymongo import MongoClient
import uuid

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup_event():
    print("Application started!")
    app.data = []
    app.client = MongoClient("mongodb://35.180.186.141:27017/")
    app.db = app.client["ta_db"]
    app.collection = app.db["ta_db"]


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello")
async def hello():
    list = app.collection.find()
    return list

class Person(BaseModel):
    uuid: str
    firstName: str
    lastName: str
    age: int
    profession: str

class AddPerson(BaseModel):
    firstName: str
    lastName: str
    age: int
    profession: str

@app.post("/hello")
async def hello(person: AddPerson):
    person = Person(uuid=str(uuid.uuid4()), **person.dict())
    app.data.append(person)
    return person