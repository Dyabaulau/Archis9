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
    app.client = MongoClient("mongodb+srv://admin:password1234@cluster0.fdiyvvy.mongodb.net/?retryWrites=true&w=majority")
    app.db = app.client["arinf"]
    app.collection = app.db["arinf_member"]


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello")
async def hello():
    data = list(app.collection.find({}, {"_id": 0}))
    return data

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
    app.collection.insert_one(person.dict())
    return person